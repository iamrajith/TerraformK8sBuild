#!/home/rajith/anaconda3/bin/python3
# Define the path to the existing file
import subprocess
#The base template of the Certificate signing request 
file_path_template  = "CertificateSigningRequest.yaml"

# Base filename
base_filename = "CertificateSigningRequestuser"

# Number of users, howmay participents are avilable
num_users = 10

# Generate filenames
for i in range(1, num_users + 1):
    filename = f"{base_filename}{i}.yaml"
    user = f"user{i}"
    # Run commands,The following command is to generate PKI private key and CSR.
    genrate_key = f"openssl genrsa -out {user}.key 2048"
    genrate_csr = f'openssl req -new -key {user}.key -out {user}.csr -subj "/CN={user}"'
    subprocess.call( genrate_key, shell=True)
    subprocess.call(genrate_csr, shell=True)
    # Read the existing content from the file , reading the template
    with open(file_path_template, "r") as file:
        file_content = file.read()

    # Specify the target string to replace
    target_string = "change2"
    target_user = "change1"
  
    # Decode the CSR file , so that is can be directly added to the CertificateS igning Request
    decode_encripption = f'cat {user}.csr | base64 | tr -d "\n"' 
    new_value = subprocess.check_output(decode_encripption, shell=True).decode("utf-8").strip()

    modified_content = file_content.replace(target_string, new_value).replace(target_user, user)

    # Write the modified content to the new file
    with open(filename, "w") as new_file:
        new_file.write(modified_content)
    print(f"The CertificateS igning Request for the {user} has been created.")
    # Submit CertificateSigningRequest to the Kubernetes Cluster via kubectl. 
    submit_certificate_signingRequest = f'kubectl apply -f {filename}'
    subprocess.call(submit_certificate_signingRequest, shell=True)

# Prompt for validation 
print(f"Please perform a manul validation before proceding, verify the csr request is in place") 
user_response = input("Please validate (type 'yes' or 'no'): ")

# Check if the user provided valid input
while user_response.lower() not in ('yes', 'no'):
    print("Invalid input. Please type 'yes' or 'no'.")
    user_response = input("Please validate: ")

# Continue with the remaining part of your script
if user_response.lower() == 'yes':
    print("Continuing with the script.")
else:
    print(" Exiting the script.")


# Get the certificate ,Retrieve the certificate from the CSR: 

for i in range(1, num_users + 1):
    filename = f"{base_filename}{i}.yaml"
    user = f"user{i}"
    # Approve the CSR
    approve_user = f"kubectl certificate approve {user}"
    #Export the issued certificate from the CertificateSigningRequest.
    export_certificate = f"kubectl get csr {user} -o jsonpath='{{.status.certificate}}' | base64 -d > {user}.crt"
    subprocess.call( approve_user, shell=True)
    subprocess.call(export_certificate, shell=True)