#!/home/rajith/anaconda3/bin/python3
import subprocess
num_users = 10

# Generate filenames
for i in range(1, num_users + 1):
    filename = f"{base_filename}{i}.yaml"
    user = f"user{i}"
    # Approve the CSR
    approve_user = f"kubectl certificate approve {user}"
    #Export the issued certificate from the CertificateSigningRequest.
    # Run the command to get the certificate
    export_certificate = f"kubectl get csr {user} -o jsonpath='{{.status.certificate}}' | base64 -d > {user}.crt"
    # Execute the command
    subprocess.call( approve_user, shell=True)
    subprocess.call(export_certificate, shell=True)


print("All the CSR file has been generated")

