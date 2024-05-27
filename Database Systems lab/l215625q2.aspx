<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="s2.aspx.cs" Inherits="WebApplication1.s2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body><center>
    <h1>To Illustrate Form Based Tags</h1>
    <hr width="100%" color="red" />
    <form id="form1" runat="server">
    <div>
    
         <tr>
                     <td>
                       this is a text box to enter any text
                    </td>
                    <td>
				<input type=”name”  placeholder=”” name=””>
			</td>
                </tr>
        <br />
        <tr>
<td>
				 This is a text box to enter Password:
			</td>

			<td>
				<input type=”Password” placeholder=”” name=””>
			</td>
		</tr>
        <br />
        this is a button to enter big text
         <asp:TextBox ID="txtComment" TextMode="multiline"
runat="server"></asp:TextBox>
        <br />
        this is a button
        <asp:Button ID="btnSave" Text="button" runat="server" />
        <br />
        <b>Radio Buttons</b>
        <asp:RadioButton ID="rdMale" GroupName="Gender"
runat="server" />
<asp:RadioButton ID="rdFemale" GroupName="Gender"
runat="server" />
        &nbsp
        <br />
        Checkbox Options
        <br />
        sunday
        <asp:CheckBox ID="chkIsStudent" runat="server" />
        &nbsp
        Monday
        <asp:CheckBox ID="CheckBox1" runat="server" />
        &nbsp
        Tuestday
        <asp:CheckBox ID="CheckBox2" runat="server" />
        <br />
        Menu driven box
        <asp:DropDownList ID="ddlDepartment" runat="server">
<asp:ListItem Text="Select" Value="0"></asp:ListItem>
<asp:ListItem Text="Volvo"
Value="CS"></asp:ListItem>
<asp:ListItem Text="Suzuki"
Value="EE"></asp:ListItem>
<asp:ListItem Text="Honda"
Value="BBA"></asp:ListItem>
<asp:ListItem Text="Audi"
Value="CV"></asp:ListItem>
</asp:DropDownList>

    </div>
    </form>
    </center>
</body>
</html>
