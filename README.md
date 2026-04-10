# AWS Resource Report Script

A Bash script that audits your AWS account and generates a timestamped report of all key resources — S3 Buckets, EC2 Instances, Lambda Functions, and IAM Users.

---

## Author

**Samarth Chinde**  
B.Tech IT Student | Cloud & DevOps Enthusiast  
[LinkedIn](https://linkedin.com/in/samarthchinde)

---

## What This Script Does

When executed, this script will:

1. Validate that AWS CLI is properly configured on your machine
2. Fetch a list of all S3 Buckets in your account
3. Fetch all EC2 Instance IDs
4. Fetch all Lambda Functions
5. Fetch all IAM User IDs
6. Save everything into a timestamped `.txt` report file
7. Print the same output to your terminal in real time

---

## Prerequisites

Before running this script, make sure the following are installed and configured on your machine.

### 1. AWS CLI

Install AWS CLI on Linux:

```bash
sudo apt install awscli -y
```

Verify installation:

```bash
aws --version
```

### 2. jq (JSON Parser)

The script uses `jq` to extract specific fields from AWS JSON responses.

```bash
sudo apt install jq -y
```

Verify installation:

```bash
jq --version
```

### 3. AWS CLI Configuration

Configure your AWS credentials by running:

```bash
aws configure
```

You will be prompted for 4 things:

```
AWS Access Key ID:      → Your Access Key ID from AWS Console
AWS Secret Access Key:  → Your Secret Access Key from AWS Console
Default region name:    → ap-south-1  (Mumbai region)
Default output format:  → json
```

To get your Access Key ID and Secret Access Key:
- Log in to AWS Console
- Click your account name (top right) → Security Credentials
- Go to Access Keys → Create Access Key → Select CLI → Create

> ⚠️ Never share your access keys. Never push them to GitHub.

Verify your configuration works:

```bash
aws sts get-caller-identity
```

If configured correctly, you will see your Account ID and ARN printed on screen.

---

## How to Download and Run the Script

### Step 1 — Clone the Repository

```bash
git clone https://github.com/your-username/bash-devops-scripts.git
cd bash-devops-scripts
```

### Step 2 — Give Execute Permission

Before running any bash script, you must give it execute permission:

```bash
chmod +x aws_resource_report.sh
```

`chmod +x` means "add execute permission to this file". Without this step, the script will not run.

### Step 3 — Run the Script

```bash
./aws_resource_report.sh
```

The `./` means "run this file from the current directory".

---

## What Happens When You Run It

```
This report is of date Fri Apr 10 11:38:03 AM UTC 2026.

List of S3 Buckets:-
2025-12-24 15:55:15 samarth-first-bucket
2025-12-24 16:25:10 samarth-second-bucket

List of EC2 Instances:-
"i-0abc123def456gh78"

List of Lambda Functions:-
(empty if no functions exist)

List of IAM Users:-
"AIDATLAECTEFSFMN3BUZT"
"AIDATLAECTEFYXD7EKZQ2"

======================================
Report saved → aws_resource_report_2026-04-10_11-38-03.txt
Location     → /home/vboxuser/gitrepo
```

---

## Output Report File

Every time the script runs, it creates a **new uniquely named report file** using the current timestamp:

```
aws_resource_report_2026-04-10_11-38-03.txt
```

This means every run is saved separately — you will never overwrite a previous report.

To read any saved report:

```bash
cat aws_resource_report_2026-04-10_11-38-03.txt
```

---

## Script Breakdown — Line by Line

### Block 1: Shebang and Header Comments

```bash
#!/bin/bash
# Author: Samarth Chinde
# Version: v1
# This script will report the AWS resource usage
```

`#!/bin/bash` tells the operating system to run this file using Bash. The `#` lines are comments — they are ignored by the computer and exist only for documentation.

### Block 2: AWS CLI Validation

```bash
if ! aws sts get-caller-identity &>/dev/null; then
    echo "ERROR: AWS CLI not configured. Run 'aws configure' first."
    exit 1
fi
```

Before doing anything, the script checks if AWS CLI is properly configured. `aws sts get-caller-identity` silently verifies your credentials. If it fails, the script prints an error and stops immediately. There is no point running the rest if AWS is not set up.

### Block 3: Dynamic Report Filename

```bash
REPORT="aws_resource_report_$(date +%Y-%m-%d_%H-%M-%S).txt"
```

`$(date +%Y-%m-%d_%H-%M-%S)` inserts the current date and time into the filename. Example: `aws_resource_report_2026-04-10_11-38-03.txt`. Every run creates a fresh file.

### Block 4: S3 Buckets

```bash
s3=$(aws s3 ls)
echo "$s3" | tee -a $REPORT
```

`aws s3 ls` lists all S3 buckets. The result is stored in the variable `s3`. `tee -a` prints it to the terminal AND appends it to the report file in one step — instead of running the AWS command twice.

### Block 5: EC2 Instances

```bash
ec2=$(aws ec2 describe-instances)
echo "$ec2" | jq '.Reservations[].Instances[].InstanceId' | tee -a $REPORT
```

`aws ec2 describe-instances` returns a large JSON object. `jq` is used to extract only the Instance IDs from that JSON, making the output clean and readable.

### Block 6: Lambda Functions

```bash
lambda=$(aws lambda list-functions)
echo "$lambda" | jq '.Functions[].FunctionName' | tee -a $REPORT
```

Lists all Lambda functions and extracts just the function names using `jq`.

### Block 7: IAM Users

```bash
IAM=$(aws iam list-users)
echo "$IAM" | jq '.Users[].UserId' | tee -a $REPORT
```

Lists all IAM users in your account and extracts their User IDs.

### Block 8: Completion Message

```bash
echo "Report saved → $REPORT"
echo "Location     → $(pwd)"
```

Tells you the name of the saved report file and the directory where it was created. `$(pwd)` prints the current working directory.

---

## IAM Permissions Required

Your AWS IAM user must have at least the following read permissions to run this script:

| AWS Service | Permission Required |
|---|---|
| S3 | `s3:ListAllMyBuckets` |
| EC2 | `ec2:DescribeInstances` |
| Lambda | `lambda:ListFunctions` |
| IAM | `iam:ListUsers` |
| STS | `sts:GetCallerIdentity` |

For practice, you can attach the **ReadOnlyAccess** managed policy to your IAM user — it covers all of the above safely.

---

## Key Concepts Used

| Concept | What it does |
|---|---|
| `#!/bin/bash` | Declares the script runs in Bash |
| `$()` | Command substitution — stores command output in a variable |
| `tee -a` | Writes output to both terminal and file simultaneously |
| `jq` | Parses and filters JSON output from AWS CLI |
| `&>/dev/null` | Suppresses all output (used for silent checks) |
| `if ! command` | Runs block if command fails |
| `exit 1` | Stops the script with an error code |
| `$(date +...)` | Formats current date/time for use in filenames |

---

## Related Projects

- [GitHub API Bash Script](./github_api.sh) — Communicates with the GitHub REST API and handles pagination

---

## License

This project is open source and available for learning purposes.
