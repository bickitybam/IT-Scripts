########################################################################
# Name: Lync DNS Tester Tool 
# Version: v1.0.0 (1/3/2014)
# Date: 1/3/2014
# Created By: James Cussen
# Web Site: http://www.mylynclab.com
#
# Notes: This is a Powershell tool. To run the tool, open it from the Powershell command line or Right Click and select "Run with Powershell".
# 		 For more information on the requirements for setting up and using this tool please visit http://www.mylynclab.com.
#
# Copyright: Copyright (c) 2014, James Cussen (www.mylynclab.com) All rights reserved.
# Licence: 	Redistribution and use of script, source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#				1) Redistributions of script code must retain the above copyright notice, this list of conditions and the following disclaimer.
#				2) Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#				3) Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#			THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; LOSS OF GOODWILL OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Release Notes:
# 1.00 Initial Release.
# 		
########################################################################

# The variables below are used for the "Fill All" button in pressed to quick load the DNS names. Change these variables as required to match your system or deployment standard.

# External DNS Name Variables - Edit these to whatever you are using for your Lync environment
$sip = "sip"  				# External Access Edge
$sipnoram = "sip-noram"  				# External Access Edge - noram
$sipemea = "sip-emea"  				# External Access Edge - emea
$sipapac = "sip-apac"  				# External Access Edge - apac
<# $av = "av"  				# External AV Edge
$webconf = "webconf"		# External Web Conf
$lyncwebext = "lyncwebext"	# Lync External Web Services / Reverse Proxy
$dialin = "dialin"			# dialin conferencing name
$meet = "meet"				# meet conferencing name
$waswebext = "waswebext"	# Web Apps server external name #>

# Internal DNS Name Variables - Edit these to whatever you are using for your Lync environment
$wasweb = "wasweb"			# Internal Web Apps Server
$admin = "admin"			# Lync administrator web access


# boolean for cancelling lookup
$script:CancelScan = $false

# Set up the form  ============================================================

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Lync DNS Tester Tool v1.00"
$objForm.Size = New-Object System.Drawing.Size(992,760) 
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True
$objForm.TabStop = $false


#Domain Label ============================================================
$DomainLabel = New-Object System.Windows.Forms.Label
$DomainLabel.Location = New-Object System.Drawing.Size(25,22) 
$DomainLabel.Size = New-Object System.Drawing.Size(50,15) 
$DomainLabel.Text = "Domain: "
$DomainLabel.TabStop = $false
$objForm.Controls.Add($DomainLabel)

#Domain Text box ============================================================
$DomainTextBox = new-object System.Windows.Forms.textbox
$DomainTextBox.location = new-object system.drawing.size(90,20)
$DomainTextBox.size= new-object system.drawing.size(150,15)
$DomainTextBox.text = ""
$DomainTextBox.TabIndex = 1
$DomainTextBox.add_KeyUp(
{
	if ($_.KeyCode -eq "Enter") 
	{	
		SetStandardDomains
	}
})
$objform.controls.add($DomainTextBox)

#Fill button
$FillAllButton = New-Object System.Windows.Forms.Button
$FillAllButton.Location = New-Object System.Drawing.Size(250,20)
$FillAllButton.Size = New-Object System.Drawing.Size(60,18)
$FillAllButton.Text = "Fill All"
$FillAllButton.TabStop = $false
$FillAllButton.Add_Click(
{
	SetStandardDomains
})
$objForm.Controls.Add($FillAllButton)


# Internal Checkbox ============================================================
$InternalCheckBox = New-Object System.Windows.Forms.Checkbox 
$InternalCheckBox.Location = New-Object System.Drawing.Size(140,40) 
$InternalCheckBox.Size = New-Object System.Drawing.Size(20,20)
$InternalCheckBox.TabIndex = 2
$InternalCheckBox.Add_Click({
	$InternalCheckBox.checked = $true
	$ExternalCheckBox.checked = $false
	
})
$objForm.Controls.Add($InternalCheckBox) 

$InternalLabel = New-Object System.Windows.Forms.Label
$InternalLabel.Location = New-Object System.Drawing.Size(90,43) 
$InternalLabel.Size = New-Object System.Drawing.Size(45,15) 
$InternalLabel.Text = "Internal:"
$InternalLabel.TabStop = $false
$objForm.Controls.Add($InternalLabel)

# External Checkbox ============================================================
$ExternalCheckBox = New-Object System.Windows.Forms.Checkbox 
$ExternalCheckBox.Location = New-Object System.Drawing.Size(140,60) 
$ExternalCheckBox.Size = New-Object System.Drawing.Size(20,20)
$ExternalCheckBox.TabIndex = 3
$ExternalCheckBox.Add_Click({
	$InternalCheckBox.checked = $false
	$ExternalCheckBox.checked = $true
	
})
$objForm.Controls.Add($ExternalCheckBox) 

$ExternalLabel = New-Object System.Windows.Forms.Label
$ExternalLabel.Location = New-Object System.Drawing.Size(90,63) 
$ExternalLabel.Size = New-Object System.Drawing.Size(50,15) 
$ExternalLabel.Text = "External:"
$ExternalLabel.TabStop = $false
$objForm.Controls.Add($ExternalLabel)


# IPv6 Checkbox ============================================================
$IPv6CheckBox = New-Object System.Windows.Forms.Checkbox 
$IPv6CheckBox.Location = New-Object System.Drawing.Size(215,50) 
$IPv6CheckBox.Size = New-Object System.Drawing.Size(20,20)
$IPv6CheckBox.TabIndex = 3
$IPv6CheckBox.Add_Click({
	
})
$objForm.Controls.Add($IPv6CheckBox) 

$IPv6Label = New-Object System.Windows.Forms.Label
$IPv6Label.Location = New-Object System.Drawing.Size(180,53) 
$IPv6Label.Size = New-Object System.Drawing.Size(40,15) 
$IPv6Label.Text = "IPv6:"
$IPv6Label.TabStop = $false
$objForm.Controls.Add($IPv6Label)


#Host Name Label ============================================================
$HostNameLabel = New-Object System.Windows.Forms.Label
$HostNameLabel.Location = New-Object System.Drawing.Size(25,87) 
$HostNameLabel.Size = New-Object System.Drawing.Size(65,15) 
$HostNameLabel.Text = "Host Name: "
$HostNameLabel.TabStop = $false
$objForm.Controls.Add($HostNameLabel)

#Host Name Text box ============================================================
$HostNameTextBox = new-object System.Windows.Forms.textbox
$HostNameTextBox.location = new-object system.drawing.size(90,85)
$HostNameTextBox.size= new-object system.drawing.size(150,15)
$HostNameTextBox.text = ""
$HostNameTextBox.TabIndex = 4
$objform.controls.add($HostNameTextBox)

#Domain Add button
$DomainNameAddButton = New-Object System.Windows.Forms.Button
$DomainNameAddButton.Location = New-Object System.Drawing.Size(250,98)
$DomainNameAddButton.Size = New-Object System.Drawing.Size(60,18)
$DomainNameAddButton.Text = "Add"
$DomainNameAddButton.TabStop = $false
$DomainNameAddButton.Add_Click(
{
	[string]$HostName = $HostNameTextBox.Text
	if($DomainTextBox.Text -ne "")
	{
		if($HostNameTextBox.Text -ne "")
		{
			$Record = $RecordTypeDropDownBox.SelectedItem
			[string]$Domain = $DomainTextBox.Text
			[string]$Name = $HostNameTextBox.Text
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${Name}.${Domain}")
			
			[void]$DomainNameListboxItem.SubItems.Add($Record)
			$DomainNameListboxItem.ForeColor = "Blue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
		}
		else
		{
			Write-Host "ERROR: No Hostname specified." -foreground "red"
		}
	}
	else
	{
		Write-Host "ERROR: No Domain Name specified." -foreground "red"
	}
})
$objForm.Controls.Add($DomainNameAddButton)

#Domain Remove button
$DomainNameRemoveButton = New-Object System.Windows.Forms.Button
$DomainNameRemoveButton.Location = New-Object System.Drawing.Size(100,290)
$DomainNameRemoveButton.Size = New-Object System.Drawing.Size(70,20)
$DomainNameRemoveButton.Text = "Delete"
$DomainNameRemoveButton.TabStop = $false
$DomainNameRemoveButton.Add_Click(
{
	while($DomainNameListbox.SelectedItems.Count -ne 0)
    {
        [void]$DomainNameListbox.Items.Remove($DomainNameListbox.SelectedItems[0])
    }
})
$objForm.Controls.Add($DomainNameRemoveButton)


#Domain Clear button
$DomainNameClearButton = New-Object System.Windows.Forms.Button
$DomainNameClearButton.Location = New-Object System.Drawing.Size(180,290)
$DomainNameClearButton.Size = New-Object System.Drawing.Size(70,20)
$DomainNameClearButton.Text = "Clear All"
$DomainNameClearButton.TabStop = $false
$DomainNameClearButton.Add_Click(
{
		[void]$DomainNameListbox.Items.Clear()
})
$objForm.Controls.Add($DomainNameClearButton)


#Record Type Label ============================================================
$RecordTypeLabel = New-Object System.Windows.Forms.Label
$RecordTypeLabel.Location = New-Object System.Drawing.Size(25,107) 
$RecordTypeLabel.Size = New-Object System.Drawing.Size(50,15) 
$RecordTypeLabel.Text = "Type: "
$RecordTypeLabel.TabStop = $false
$objForm.Controls.Add($RecordTypeLabel)

#Record Drop Down box ============================================================
$RecordTypeDropDownBox = New-Object System.Windows.Forms.ComboBox 
$RecordTypeDropDownBox.Location = New-Object System.Drawing.Size(90,107) 
$RecordTypeDropDownBox.Size = New-Object System.Drawing.Size(150,15) 
$RecordTypeDropDownBox.DropDownStyle = "DropDownList"
$RecordTypeDropDownBox.DropDownHeight = 60 
$RecordTypeDropDownBox.tabIndex = 5
$objForm.Controls.Add($RecordTypeDropDownBox) 

$DNSTypes = @("A","SRV","CNAME","AAAA")
foreach($DNSType in $DNSTypes)
{
	[void] $RecordTypeDropDownBox.Items.Add($DNSType)
}

$numberOfItems = $RecordTypeDropDownBox.items.count
if($numberOfItems -gt 0)
{
	$RecordTypeDropDownBox.SelectedIndex = 0
}


#DNS Server Label ============================================================
$DNSServerLabel = New-Object System.Windows.Forms.Label
$DNSServerLabel.Location = New-Object System.Drawing.Size(30,320) 
$DNSServerLabel.Size = New-Object System.Drawing.Size(70,15) 
$DNSServerLabel.Text = "DNS Server: "
$DNSServerLabel.TabStop = $false
$objForm.Controls.Add($DNSServerLabel)

#DNS Server Text box ============================================================
$DNSServerTextBox = new-object System.Windows.Forms.textbox
$DNSServerTextBox.location = new-object system.drawing.size(100,320)
$DNSServerTextBox.size= new-object system.drawing.size(150,15)
$DNSServerTextBox.text = "8.8.8.8"
$DNSServerTextBox.TabIndex = 6
$objform.controls.add($DNSServerTextBox)


# Listbox of FQDNS ============================================================
$DomainNameListbox = New-Object windows.forms.ListView
$DomainNameListbox.View = [System.Windows.Forms.View]"Details"
$DomainNameListbox.Size = New-Object System.Drawing.Size(293,150)
$DomainNameListbox.Location = New-Object System.Drawing.Size(30,135)
$DomainNameListbox.FullRowSelect = $true
$DomainNameListbox.GridLines = $true
$DomainNameListbox.HideSelection = $false
$DomainNameListbox.Sorting = [System.Windows.Forms.SortOrder]"Ascending"
[void]$DomainNameListbox.Columns.Add("FQDN", 220)
[void]$DomainNameListbox.Columns.Add("Type", 50)
$DomainNameListbox.TabStop = $false
$objForm.Controls.Add($DomainNameListbox)


# Test button
$TestButton = New-Object System.Windows.Forms.Button
$TestButton.Location = New-Object System.Drawing.Size(100,350)
$TestButton.Size = New-Object System.Drawing.Size(150,25)
$TestButton.Text = "Test"
$TestButton.TabIndex = 6
$TestButton.Add_Click(
{
	$script:CancelScan = $false
	$TestButton.Visible = $false
	$CancelTestButton.Visible = $true
	$TestButton.Enabled = $false
	$DomainNameRemoveButton.Enabled = $false
	$DomainNameClearButton.Enabled = $false
	$DomainNameAddButton.Enabled = $false
	$FillAllButton.Enabled = $false
	$DNSServerTextBox.Enabled = $false
	Test-DNS
	$TestButton.Enabled = $true
	$DomainNameRemoveButton.Enabled = $true
	$DomainNameClearButton.Enabled = $true
	$DomainNameAddButton.Enabled = $true
	$FillAllButton.Enabled = $true
	$DNSServerTextBox.Enabled = $true
	$TestButton.Visible = $true
	$CancelTestButton.Visible = $false
})
$objForm.Controls.Add($TestButton)


# Test button
$CancelTestButton = New-Object System.Windows.Forms.Button
$CancelTestButton.Location = New-Object System.Drawing.Size(100,350)
$CancelTestButton.Size = New-Object System.Drawing.Size(150,25)
$CancelTestButton.Text = "Cancel Test"
$CancelTestButton.ForeColor = "red"
$CancelTestButton.TabStop = $false
$CancelTestButton.Add_Click(
{
	$script:CancelScan = $true
	
	$DomainNameRemoveButton.Enabled = $true
	$DomainNameClearButton.Enabled = $true
	$DomainNameAddButton.Enabled = $true
	$FillAllButton.Enabled = $true
	$DNSServerTextBox.Enabled = $true
	$CancelTestButton.Visible = $false
	$TestButton.Visible = $true
	$TestButton.Enabled = $true
	
})
$objForm.Controls.Add($CancelTestButton)


$objInfoLabel = New-Object System.Windows.Forms.Label
$objInfoLabel.Location = New-Object System.Drawing.Size(340,15) 
$objInfoLabel.Size = New-Object System.Drawing.Size(200,15) 
$objInfoLabel.Text = "Information:"
$objInfoLabel.TabStop = $false
$objForm.Controls.Add($objInfoLabel)


#Info Box
$FontCourier = new-object System.Drawing.Font("Lucida Console",8,[Drawing.FontStyle]'Regular')
$InformationTextBox = New-Object System.Windows.Forms.RichTextBox 
$InformationTextBox.Location = New-Object System.Drawing.Size(340,30)
$InformationTextBox.Size = New-Object System.Drawing.Size(625,680)  
$InformationTextBox.Font = $FontCourier
$InformationTextBox.Multiline = $True	
#$InformationTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
#$InformationTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Horizontal
$InformationTextBox.Wordwrap = $false
$InformationTextBox.Text = ""
$InformationTextBox.TabStop = $false
$objForm.Controls.Add($InformationTextBox) 

# Tool tips for Help!
$ToolTip = New-Object System.Windows.Forms.ToolTip 
$ToolTip.BackColor = [System.Drawing.Color]::LightGoldenrodYellow 
$ToolTip.IsBalloon = $true 
$ToolTip.InitialDelay = 500 
$ToolTip.ReshowDelay = 500 
$ToolTip.AutoPopDelay = 10000
$ToolTip.SetToolTip($DomainTextBox, "Enter the Domain Name of the Lync system. (eg. contoso.com)") 
$ToolTip.SetToolTip($HostNameTextBox, "Enter only the Host Name portion of the record. (eg. dialin)") 
$ToolTip.SetToolTip($FillAllButton, "Click this button to fill all of the default FQDNs into the list box.`r`nYou must have entered the domain name in the Domain text box for this to work.") 
$ToolTip.SetToolTip($DNSServerTextBox, "Enter the DNS server IP Address that you would like the records requested from.`r`nFor internal records you would enter the internal DNS server.`r`nFor External records you would enter an external DNS server (example 8.8.8.8 for google's DNS)") 
$ToolTip.SetToolTip($IPv6CheckBox, "Check this box when IPv6 is used so that the Fill All button uses AAAA records.") 
$ToolTip.SetToolTip($ExternalCheckBox, "Check this box to fill all the External records when the Fill All button is pressed.") 
$ToolTip.SetToolTip($InternalCheckBox, "Check this box to fill all the Internal records when the Fill All button is pressed.") 
$ToolTip.SetToolTip($DomainNameAddButton, "Click this button to add the domain to the list.") 
$ToolTip.SetToolTip($TestButton, "Click this button to test all the Domain Names in the List.") 

function SetStandardDomains
{
	[String]$DomainName = $DomainTextBox.Text
	
	if($DomainName -ne "")
	{
		if($IPv6CheckBox.Checked)
		{
			$ARecordType = "AAAA"
		}
		else
		{
			$ARecordType = "A"
		}
		if($ExternalCheckBox.Checked)
		{
						
			# External access name
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${sip}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)

			# External access name for noram
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${sipnoram}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)

			# External access name for emea
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${sipemea}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# External access name for apac
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${sipapac}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			<# # External av name
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${av}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# External web conferencing name
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${webconf}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# External Web Services name / Reverse Proxy
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${lyncwebext}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Dial-in simple name / Reverse Proxy
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${dialin}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Meet simple name / Reverse Proxy
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${meet}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)

			# External Web Apps Server / Reverse Proxy
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${waswebext}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem) #>
			
			# Lync discover record for Mobile and Windows 8 client
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("lyncdiscover.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)

			<# # External SIP record - Not Variable
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("sipexternal.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem) #>
			
			# External SRV record for SIP connection
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("_sip._tls.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add("SRV")
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# External Federation SRV record for Open Federation
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("_sipfederationtls._tcp.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add("SRV")
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			
			<# # External XMPP Federation SRV record
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("_xmpp-server._tcp.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add("SRV")
			$DomainNameListboxItem.ForeColor = "DarkBlue"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem) #>
	
			
		}
		if($InternalCheckBox.Checked)
		{

			# Dial-in simple record internal
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${dialin}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Meet simple record internal
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${meet}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Lync Web external - Mobile clients
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${lyncwebext}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Web Apps farm internal name
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${wasweb}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)

			# Admin console Simple name
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("${admin}.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)

			# SIP record - Not Variable
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("sip.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Internal SIP record - Not Variable
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("sipinternal.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# Lync Discover Internal - Mobile App - Not Variable
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("lyncdiscoverinternal.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add($ARecordType)
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
			# SIP internal SRV record - Not Variable
			$DomainNameListboxItem = new-object System.Windows.Forms.ListViewItem("_sipinternaltls._tcp.$DomainName")
			[void]$DomainNameListboxItem.SubItems.Add("SRV")
			$DomainNameListboxItem.ForeColor = "Green"
			[void]$DomainNameListbox.Items.Add($DomainNameListboxItem)
			
		}
	}
}


#Using Powershell v2 safe command nslookup instead of powershell command Resolve-DnsName
function Test-DNS
{
	$InformationTextBox.Clear()

	foreach($DomainName in $DomainNameListbox.Items)
	{
	
		[string]$Name = $DomainName.Text
		$SubItems = $DomainName.SubItems
		[string]$RecordTypeString = $SubItems[1].Text
		[string]$NameServerQueried = $DNSServerTextBox.text
		
		#Powershell v2 safe nslookup
		Write-Host "COMMAND: nslookup -type=${RecordTypeString} $Name $NameServerQueried" -foreground "green"
		
		##Build Cmd to start the tracing without duration
		[string]$cmd = "nslookup -type=${RecordTypeString} $Name $NameServerQueried"
		
		##Execute CLS Start tracing cmd
		write-host "--------------------------------------------------------------------------------------------"
		write-host "RUNNING COMMAND: $cmd"
		
		$pinfo = New-Object System.Diagnostics.ProcessStartInfo
		$pinfo.FileName = "powershell.exe"
		$pinfo.RedirectStandardError = $true
		$pinfo.RedirectStandardOutput = $true
		$pinfo.UseShellExecute = $false
		$pinfo.Arguments = "-command `"$cmd`""
		$p = New-Object System.Diagnostics.Process
		$p.StartInfo = $pinfo
		$p.Start() | Out-Null
		$p.WaitForExit()
		[string]$stdout = $p.StandardOutput.ReadToEnd()
		[string]$stderr = $p.StandardError.ReadToEnd()
		write-host "--------------------------------------------------------------------------------------------"
		
		write-host $stderr
				
		$FullAddressList = $stdout
		
		
		$FullAddressSplit = $FullAddressList.Replace("`r`n","`n").Split("`n")
				
		#Originally 61 chars, changed to 81. And added 20 to all other numbers not 1 or 0
		$InformationTextBox.Text += "+---------------------------------------------------------------------------------+`n"
		$InformationTextBox.Text += "| ${RecordTypeString} RECORD: $Name"
		For ($i = 71 - $Name.length - $RecordTypeString.length; $i -gt 0; $i--)
		{
				$InformationTextBox.Text += " "
		}
		$InformationTextBox.Text += "|`n"
		$InformationTextBox.Text += "+---------------------------------------------------------------------------------+`n"
		
		if($stderr -ne "")
		{
			$stderr = $stderr.Trim()
			$stderr = "`"$stderr`""
			[int] $noOfLines = [System.Math]::Ceiling($stderr.length / 79)
			$errorStringArray = new-object object[] $noOfLines
			$rowLength = 79
			For ($i = 0 ; $i -lt $noOfLines; $i++)
			{
				if(($i + 1) -eq  $noOfLines)
				{
					$rowLength = $stderr.length - (($noOfLines - 1) * 79)
				}
				[int] $StartInt = ($i * 79)
				[int] $EndInt = (($i * 79) + $rowLength)
				$errorStringArray[$i] = $stderr.Substring($StartInt,($EndInt - $StartInt))
			}
			
			$InformationTextBox.Text += "| INFO:                                                                           |`n"
			$InformationTextBox.Text += "|                                                                                 |`n"
		
			foreach($errorString in $errorStringArray)
			{
				$InformationTextBox.Text += "| "
				$InformationTextBox.Text += $errorString
				For ($i = 80 - $errorString.length ; $i -gt 0; $i--)
				{
					$InformationTextBox.Text += " "
				}
				$InformationTextBox.Text += "|`n"
				
			}
			$InformationTextBox.Text += "|                                                                                 |`n"
		
		}
		
		$InformationTextBox.Text += "+---------------------------------------------------------------------------------+`n"
		$InformationTextBox.Text += "| RESPONSE:                                                                       |`n"
		$InformationTextBox.Text += "|                                                                                 |`n"
		
		foreach($line in $FullAddressSplit)
		{
			$line = $line.Replace("`t", "      ")
			$InformationTextBox.Text += "| $line"
			For ($i = 80 - $line.length ; $i -gt 0; $i--)
			{
				$InformationTextBox.Text += " "
			}
			$InformationTextBox.Text += "|`n"
			Write-Host $line
		}
		write-host "--------------------------------------------------------------------------------------------"
		
		$InformationTextBox.Text += "+---------------------------------------------------------------------------------+`n"
		
		write-host ""
				
		$InformationTextBox.Text += "`n`n"
		$InformationTextBox.Select($InformationTextBox.Text.Length - 1, 0)
		$InformationTextBox.ScrollToCaret()
		[System.Windows.Forms.Application]::DoEvents()
		#Stop loop
		if($CancelScan)
		{break}

	}
	
}

$ExternalCheckBox.Checked = $true

# Activate the form ============================================================
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()	


