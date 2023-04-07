import subprocess
import os
import tkinter as tk
from tkinter import ttk

class SysctlManager:
    def __init__(self, master):
        self.master = master
        master.title("Sysctl Manager")
        master.geometry("800x600")
        
        # create a scrollable listbox with a scrollbar
        self.scrollbar = ttk.Scrollbar(master)
        self.scrollbar.pack(side="right", fill="y")
        self.listbox = tk.Listbox(master, yscrollcommand=self.scrollbar.set)
        self.listbox.pack(side="left", fill="both", expand=True)
        self.scrollbar.config(command=self.listbox.yview)
        
        # add a button to update the values
        self.button = ttk.Button(master, text="Update Values", command=self.update_values)
        self.button.pack()
        
        # fetch and display the current sysctl values
        self.update_values()
        
    def update_values(self):
        # clear the listbox
        self.listbox.delete(0, tk.END)
        os.system('sh -c "sysctl -a | tee sysctl.conf > /dev/null"')        
        # get the current sysctl values
        output = subprocess.check_output("sysctl -a", shell=True)
        values = output.decode().split("\n")
        
        # add the values to the listbox
        for value in values:
            if not value:
                continue
            
            # split the parameter and value
            parameter, value = value.split(" = ")
            
            # add the parameter and value to the listbox as a tuple
            self.listbox.insert(tk.END, (parameter, value.strip()))
        
    def set_value(self):
        # get the selected item from the listbox
        selected = self.listbox.curselection()
        if not selected:
            return
        
        index = selected[0]
        item = self.listbox.get(index)
        
        # create a new dialog window with an entry widget for the new value
        value = item[1]
        dialog = tk.Toplevel()
        dialog.title("Set Value for {}".format(item[0]))
        entry = ttk.Entry(dialog)
        entry.insert(0, value)
        entry.pack()
        entry.focus_set()
        
        # add a button to set the new value
        button = ttk.Button(dialog, text="Set", command=lambda: self.update_value(item[0], entry.get(), dialog))
        button.pack(pady=10)
        
    def update_value(self, parameter, value, dialog):
        # set the new sysctl value
        cmd = "sudo sysctl -w {}='{}'".format(parameter, value)
        subprocess.call(cmd, shell=True)
        
        # update the value in the list
        selected = self.listbox.curselection()
        if not selected:
            return
        
        index = selected[0]
        self.listbox.delete(index)
        self.listbox.insert(index, (parameter, value))
        self.listbox.selection_set(index)
        
        # close the dialog window
        dialog.destroy()
        
# create the main window and run the application
root = tk.Tk()
app = SysctlManager(root)

# add a binding to allow the user to double-click an item to edit it
app.listbox.bind("<Double-Button-1>", lambda event: app.set_value())

root.mainloop()
