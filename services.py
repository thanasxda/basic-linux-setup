import subprocess
import tkinter as tk
from tkinter import messagebox

class ServiceManagerApp:
    def __init__(self, master):
        self.master = master
        master.title("Service Manager")
        master.geometry("800x500")

        # Create GUI elements
        self.label = tk.Label(master, text="Select a service to manage:")
        self.label.pack()
        self.frame = tk.Frame(master)
        self.frame.pack(fill=tk.BOTH, expand=True)
        self.scrollbar = tk.Scrollbar(self.frame)
        self.scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.service_list = tk.Listbox(self.frame, selectmode=tk.SINGLE, yscrollcommand=self.scrollbar.set)
        self.service_list.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.scrollbar.config(command=self.service_list.yview)
        self.refresh_button = tk.Button(master, text="Refresh", command=self.refresh_services)
        self.refresh_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.enable_button = tk.Button(master, text="Enable", command=self.enable_service)
        self.enable_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.disable_button = tk.Button(master, text="Disable", command=self.disable_service)
        self.disable_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.start_button = tk.Button(master, text="Start", command=self.start_service)
        self.start_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.stop_button = tk.Button(master, text="Stop", command=self.stop_service)
        self.stop_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.reload_button = tk.Button(master, text="Reload", command=self.reload_service)
        self.reload_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.mask_button = tk.Button(master, text="Mask", command=self.mask_service)
        self.mask_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.unmask_button = tk.Button(master, text="Unmask", command=self.unmask_service)
        self.unmask_button.pack(side=tk.LEFT, padx=5, pady=5)

        # Populate the service list
        self.refresh_services()

    def refresh_services(self):
        # Clear the service list
        self.service_list.delete(0, tk.END)

        # Get a list of all services
        try:
            output = subprocess.check_output(["systemctl", "list-unit-files", "--type", "service", "--no-pager"])
            services = output.decode().splitlines()
        except subprocess.CalledProcessError:
            messagebox.showerror("Error", "Failed to list services.")
            return

        # Add each service to the listbox
        for service in services:
            if not service.strip():  # Skip empty lines
                continue
            name = service.split()[0]
            state = "masked" if service.split()[1] == "masked" else "disabled" if service.split()[1] == "disabled" else "enabled"
            self.service_list.insert(tk.END, f"{name} [{state}]")

    def get_selected_service(self):
        # Get the selected service from the listbox
        selection = self.service_list.curselection()
        if not selection:
            messagebox.showwarning("Warning", "No service selected.")
            return None
        name = self.service_list.get(selection[0]).split()[0]
        return name

    def enable_service(self):
        # Enable the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "enable", name])
                messagebox.showinfo("Info", f"Service '{name}' enabled successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to enable service '{name}'.")

    def disable_service(self):
        # Disable the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "disable", name])
                messagebox.showinfo("Info", f"Service '{name}' disabled successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to disable service '{name}'.")

    def start_service(self):
        # Start the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "start", name])
                messagebox.showinfo("Info", f"Service '{name}' started successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to start service '{name}'.")

    def stop_service(self):
        # Stop the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "stop", name])
                messagebox.showinfo("Info", f"Service '{name}' stopped successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to stop service '{name}'.")

    def reload_service(self):
        # Reload the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "restart", name])
                messagebox.showinfo("Info", f"Service '{name}' reloaded successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to reload service '{name}'.")

    def mask_service(self):
        # Mask the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "mask", name])
                messagebox.showinfo("Info", f"Service '{name}' masked successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to mask service '{name}'.")

    def unmask_service(self):
        # Unmask the selected service
        name = self.get_selected_service()
        if name:
            try:
                subprocess.check_call(["sudo", "systemctl", "unmask", name])
                messagebox.showinfo("Info", f"Service '{name}' unmasked successfully.")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", f"Failed to unmask service '{name}'.")

root = tk.Tk()
app = ServiceManagerApp(root)
root.mainloop()

