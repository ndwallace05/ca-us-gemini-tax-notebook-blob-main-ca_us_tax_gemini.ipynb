# SOC-2 Compliant Cross-Border Tax Pipeline

This project implements a SOC-2 compliant pipeline for processing Canadian tax slips and mapping them to US tax forms. The pipeline leverages Google Cloud services for storage, OCR, and scheduling.

## Project Structure

- `ca-us-tax-pipeline-notebook.ipynb`: The main Colab Enterprise notebook containing the pipeline logic.
- `terraform/main.tf`: Terraform configuration for deploying Google Cloud resources.
- `README.md`: This file, providing an overview and setup instructions.
- `tax_form_mapping.csv`: (To be provided by user) CSV file containing the mapping from Canadian tax slip fields to US tax form fields.

## Setup and Deployment

### Prerequisites

- Google Cloud Platform (GCP) account
- Terraform installed
- `gcloud` CLI installed and configured

### 1. Provide the Tax Form Mapping CSV

Please provide the `tax_form_mapping.csv` file that maps Canadian tax slip fields to US tax form fields. This file is crucial for the pipeline's functionality.

### 2. Deploy Google Cloud Resources with Terraform

Navigate to the `terraform` directory and run the following commands:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This will create:
- A Google Cloud Storage bucket for ingesting Canadian slips.
- A Customer-Managed Encryption Key (CMEK) for data encryption.
- IAM roles with necessary permissions.
- A Cloud Scheduler job to trigger the Colab Enterprise notebook nightly.

### 3. Upload the Colab Enterprise Notebook

Once the Terraform resources are deployed, upload the `ca-us-tax-pipeline-notebook.ipynb` to your Google Colab Enterprise environment.

### 4. Configure and Run the Notebook

Inside the Colab Enterprise notebook, ensure the following are configured:
- Google Cloud Storage bucket name.
- Google Sheet ID for appending processed data.

## SOC-2 Controls Checklist

(This section will be populated with SOC-2 controls as comments within the code and configuration files.)