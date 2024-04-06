import subprocess

def update_and_install_ufw():
    try:
        # Run sudo apt update
        subprocess.run(['sudo', 'apt', 'update'], check=True)
        print("Update completed successfully.")
        # poro you can remove the update its useless but for some dummy users they forget to update and get errors so :v
        # Run sudo apt install ufw
        subprocess.run(['sudo', 'apt', 'install', 'ufw'], check=True)
        print("UFW is now installed.")
    except subprocess.CalledProcessError as e:
        print("Error:", e)

# Call the function to update and install UFW
update_and_install_ufw()

