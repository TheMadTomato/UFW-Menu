import subprocess

def install_dialog():
    try:
        # Run sudo apt update
        subprocess.run(['sudo', 'apt', 'update'], check=True)
        print("Update completed successfully.")

        # Run sudo apt install dialog
        subprocess.run(['sudo', 'apt', 'install', 'dialog', '-y'], check=True)
        print("Dialog is now installed.")
    except subprocess.CalledProcessError as e:
        print("Error:", e)

# Call the function to update and install dialog
install_dialog()

