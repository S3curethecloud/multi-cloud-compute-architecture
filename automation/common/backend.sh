#!/usr/bin/env bash
source automation/common/logger.sh

# SecureTheCloud - Terraform Backend Automation
setup_backend() {
    CLOUD="$1"

    log "Configuring Terraform backend for $CLOUD..."

    case "$CLOUD" in
    aws)
        BUCKET="stc-terraform-backend-764265373335"
        REGION="us-east-1"

        log "Checking AWS backend bucket..."

        # Create AWS S3 backend bucket properly
        if [ "$REGION" = "us-east-1" ]; then
            # us-east-1 cannot use LocationConstraint
            if ! aws s3 ls "s3://$BUCKET" >/dev/null 2>&1; then
                log "Creating S3 backend bucket (us-east-1, no LocationConstraint)..."
                aws s3api create-bucket \
                    --bucket "$BUCKET" \
                    --region "$REGION"
            else
                log "AWS backend bucket already exists."
            fi
        else
            # All other regions must include LocationConstraint
            if ! aws s3 ls "s3://$BUCKET" >/dev/null 2>&1; then
                log "Creating S3 backend bucket (regional)..."
                aws s3api create-bucket \
                    --bucket "$BUCKET" \
                    --region "$REGION" \
                    --create-bucket-configuration LocationConstraint="$REGION"
            else
                log "AWS backend bucket already exists."
            fi
        fi
        ;;

    azure)
        GROUP="stc-tf-backend"
        ACCOUNT="stctfbackend$RANDOM"
        CONTAINER="tfstate"

        log "Creating Azure backend resource group & storage..."

        # Create resource group if missing
        az group create -n "$GROUP" -l eastus >/dev/null

        # Storage account creation
        az storage account create \
            -n "$ACCOUNT" \
            -g "$GROUP" \
            -l eastus \
            --sku Standard_LRS >/dev/null

        # Create container
        az storage container create \
            --name "$CONTAINER" \
            --account-name "$ACCOUNT" >/dev/null

        log "Azure backend ready."
        ;;

    gcp)
        BUCKET="stctf-backend-central-$(openssl rand -hex 8)"

        log "Creating GCP backend bucket (if missing)..."

        if ! gsutil ls -p "$GCP_PROJECT" "gs://$BUCKET" >/dev/null 2>&1; then
            gsutil mb -p "$GCP_PROJECT" -l us-central1 "gs://$BUCKET"
            log "Created GCP backend bucket: $BUCKET"
        else
            log "GCP backend bucket already exists."
        fi

        log "GCP backend ready."
        ;;

    *)
        log_error "Unknown cloud backend: $CLOUD"
        exit 1
        ;;
    esac

    log_success "Terraform backend configured for: $CLOUD"
}
