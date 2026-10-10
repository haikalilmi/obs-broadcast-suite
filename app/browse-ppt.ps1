Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "PowerPoint Files|*.pptx;*.ppt"
$dialog.Title = "Pilih file presentasi"
$result = $dialog.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    Write-Host $dialog.FileName
} else {
    Write-Host "CANCELLED"
}
