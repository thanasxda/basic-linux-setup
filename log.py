import tkinter as tk
from tkinter import filedialog
import os
import re

class LogAnalyzer(tk.Frame):

    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.master.title("Log Analyzer")
        self.pack()
        self.create_widgets()

    def create_widgets(self):
        self.select_button = tk.Button(self, text="Select Log File", command=self.select_log_file)
        self.select_button.pack()

        self.open_button = tk.Button(self, text="Open Log File", state=tk.DISABLED, command=self.open_log_file)
        self.open_button.pack()
     
        self.analyze_firewall_button = tk.Button(self, text="Analyze Firewall", state=tk.NORMAL, command=self.analyze_firewall)
        self.analyze_firewall_button.pack()

        self.analyze_button = tk.Button(self, text="Analyze Log File", state=tk.DISABLED, command=self.analyze_log_file)
        self.analyze_button.pack()

        self.result_label = tk.Label(self, text="")
        self.result_label.pack()

    def select_log_file(self):
        file_path = filedialog.askopenfilename(initialdir="/var/log", title="Select Log File", filetypes=[("Log Files", "*.log")])
        if file_path:
            self.log_file_path = file_path
            self.open_button.config(state=tk.NORMAL)
            self.analyze_button.config(state=tk.NORMAL)

    def open_log_file(self):
        if os.path.exists(self.log_file_path):
            os.system(f"xdg-open {self.log_file_path}")
        else:
            self.result_label.config(text="Log file not found")

    def analyze_firewall(self):
        os.system("tail -f /var/log/messages | grep \"iptables\"")

    def analyze_log_file(self):
        log_file = open(self.log_file_path, "r")
        log_data = log_file.read()
        log_file.close()   
        # Count the number of error messages in the log file
        error_count = 0
        for line in log_data.splitlines():
            if re.search(r'error', line, re.IGNORECASE):
                error_count += 1
                print(line)  # print every line where an error is encountered in console
        result_text = f"Log file: {self.log_file_path}\n"
        result_text += f"Number of error messages: {error_count}\n"

        self.result_label.config(text=result_text)

root = tk.Tk()
app = LogAnalyzer(master=root)
app.mainloop()
