# Using REST with PowerShell Objects to GET and POST items
$Users = Invoke-RestMethod -Uri "http://jsonplaceholder.typicode.com/users"
$Users.Length
$Users[0].id
$Users[0].name

# Modify many items in your client-side data
$Users[0].name = "Paul Erdos"
$Users[0].username = "Paul"
$Users[0].email = "perdos@genius.org"
$Users[0].address = "No fixed address"
$Users[0].phone = ""
$Users[0].website = ""
$Users[0].company = "Maths R Us"

# PUT REST data back to update server data:
$Json = $Users[0] | ConvertTo-Json
Invoke-RestMethod -Method Put `
    -Uri "http://jsonplaceholder.typicode.com/users/1" `
    -Body $Json -ContentType 'application/json' # PUT is faked

# jsonplaceholder.typicode.com. is used by many, so
# GET always return same data for everyone every time.
# JSONPlaceholder server fakes POST, PUT, PATCH, DELETE & OPTIONS.
$Users = Invoke-RestMethod -Uri "http://jsonplaceholder.typicode.com/users/1"
$Users.Length
$Users[0].id   # not really updated because it just faked it
$Users[0].name # not really updated because it just faked it

$userpost = Invoke-RestMethod -Uri "http://jsonplaceholder.typicode.com/posts/1"
$userpost.title = "New Title"
$Json = $userpost | ConvertTo-Json 
Invoke-RestMethod -Method Put `
    -Uri "http://jsonplaceholder.typicode.com/posts/1" `
    -Body $Json -ContentType 'application/json' # PUT is faked

Invoke-RestMethod -Method Delete `
    -Uri "http://jsonplaceholder.typicode.com/posts/1" # DELETE is faked

# Using the progress bar
# VS Code does not support progress bar natively
# Need to copy/paste/run following code to PowerShell command window
1..50 | ForEach-Object {
    Write-Progress -Activity "Copying files" `
        -Status "$_ %" -Id 1 `
        -PercentComplete $_ `
        -CurrentOperation "Copying file file_name_$_.txt"
    # sleep to simulate work (e.g. file copying)    
    Start-Sleep -Milliseconds 100
}

# WPF GUI in PowerShell to list services
# Prompt for computer name and display results of calling Get-Service
Add-Type -AssemblyName PresentationFramework
 
[xml]$XAMLWindow = '
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Height="Auto"
    SizeToContent="WidthAndHeight"
    Title="Get-Service">
    <ScrollViewer Padding="10,10,10,0" ScrollViewer.VerticalScrollBarVisibility="Disabled">
        <StackPanel>
            <StackPanel Orientation="Horizontal">
                <Label Margin="10,10,0,10">ComputerName:</Label>
                <TextBox Name="Input" Margin="10" Width="250px"></TextBox>
            </StackPanel>
            <DockPanel>
                <Button Name="ButtonGetService" Content="Get-Service" Margin="10" Width="150px" IsEnabled="false"/>
                <Button Name="ButtonClose" Content="Close" HorizontalAlignment="Right" Margin="10" Width="50px"/>
            </DockPanel>
        </StackPanel>
    </ScrollViewer >
</Window>
'
# Create the Window Object
$Reader=(New-Object System.Xml.XmlNodeReader $XAMLWindow)
$Window=[Windows.Markup.XamlReader]::Load( $Reader )
# TextChanged Event Handler for Input
$TextboxInput = $Window.FindName("Input")
$TextboxInput.add_TextChanged.Invoke({
    $ComputerName = $TextboxInput.Text
    $ButtonGetService.IsEnabled = $ComputerName -ne ''
})
# Click Event Handler for ButtonClose
$ButtonClose = $Window.FindName("ButtonClose")
$ButtonClose.add_Click.Invoke({
    $Window.Close();
})
# Click Event Handler for ButtonGetService
$ButtonGetService = $Window.FindName("ButtonGetService")
$ButtonGetService.add_Click.Invoke({
    $ComputerName = $TextboxInput.text.Trim()
    try {
        Get-Service -ComputerName $computerName | `
            Out-GridView -Title "Get-Service on $ComputerName"
    }
    catch {
        [System.Windows.MessageBox]::Show( `
            $_.exception.message, `
            "Error", `
            [System.Windows.MessageBoxButton]::OK, `
            [System.Windows.MessageBoxImage]::Error
        )
    }
})

# Open the Window
$Window.ShowDialog() | Out-Null

# 


# PowerShell SQL queries

# $Query               -> SQL query to execute
# $Inst                -> server instance hosting database
# $DBName              -> database containing table
# $UID, $Password -> credentials to access database

$Query    = "SELECT * FROM Customers;"
$Server   = "mhknbn2kdz.database.windows.net"
$DbName   = "Database name"
$UID     = "sqlfamily"
$Password = "sqlf@m1ly"

# ***Invoke-Sqlcmd2 : The term 'Invoke-Sqlcmd2' is not recognized
Invoke-Sqlcmd2 -Serverinstance $Server `
    -Database $DBName -query $Query `
    -Username $UID -Password $Password

