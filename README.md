# AWS Static Site

An AWS static site running on S3 and CloudFront.

## Layout

- `/src`: the static site
- `/terraform`: infrastructure code
- `/terraform/module`: reusable module to create the static site infrastructure
- `/terraform/environment/`: environments where the module will be deployed

## How to use

### Prequisites

- Terraform or OpenTofu
- An existing Route 53 public hosted zone for your domain
- AWS CLI configured with active credentials

### Configure and Deploy

1. Navigate/create an environment inside of `terraform/environments`, e.g. `dev`.

    ```console
    $ mkdir -p terraform/environments/dev
    $ cd terraform/environments/dev
    ```

1. Set up the environment with a backend, providers, variables and to use the module. (Currently this is left vague, as I know the right way would be only pass through a single variable file. Tools that support this could be Terragunt, CLI workspaces or similar tools.)

1. Initialise the workspace

    ```console
    # terraform
    $ terraform init

    # opentofu
    $ tofu init
    ```

1. Plan/apply the deployment

    ```console
    # terraform
    $ terraform apply

    # opentofu
    $ tofu apply
    ```

## Assumptions

- All domain zones are within AWS Route 53.
- S3 bucket versioning is disabled, as the site should be in source control.

## Notes

- If CDN or custom domain wasn't required, there wouldn't be any need for CloudFront. Similarly, the CloudFront edge locations/price class can differ depending on the source of traffic.
- I chose not to use pre-made modules from github.com/terraform-aws-modules to show my understanding of the resources being created.
- As this is a fully contained project, I chose not to separate the AWS services into separate modules.
- AWS WAF was not implemented as it does not add much value to a pure static site if there's nothing to exploit.
- I did not deploy the code. The plan output is in `plan.output`

# Future Improvements

- Not use AWS CloudFront, it is expensive compared to other CDN providers.
- S3 Server Access logs for direct bucket access logging (CloudFront OAC should prevent this)
- CloudTrail logging of API activity (i.e. changes to the s3 bucket objects)
- CloudFront Access logs (viewer requests) to see who is visiting the website
- Use customer managed keys for encryption
- The variable `domain_names` doesn't support subdomains, only TLDs. This could be solved by changing it to a map and having the user provide a `list(map)` variable like `[{ domain_name: "sub.example.com", zone_id: "ABCDEFGH" }]`
- A CI/CD pipeline:
  - pushes the static site to S3 (`aws s3 sync ./src s3://bucket --delete`)
  - Quality gates such as running `fmt`, `tflint`, `tfsec` or similar tools on infrastructure code.
    - Custom `tflint` rules could be created to ensure a standard set of tags are applied (as opposed to what I used)
  - An external managed Terraform/OpenTofu tool such as Terraform Cloud, Scalr, Spacelift or env0 to do GitOps or CLI-driven deployments
- Use Terragrunt, CLI workspaces or similar tools to deploy to different environments and keep the code DRY.

## Credits

- https://html5up.net/ for the static page
