<%@ Page Title="How To" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HowTo.aspx.cs" Inherits="OhBoi.HowTo" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <h3>What does OhBoi provide?</h3>
    <p>This page is under construction, but you can find some generic instructions for the Kill Team version of <%: ConfigurationManager.AppSettings["AppName"] %> <a href="https://github.com/nyirsh/KTUI/blob/main/README.md">here</a>.</p>
</asp:Content>
