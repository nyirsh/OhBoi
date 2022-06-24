<%@ Page Title="API" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="API.aspx.cs" Inherits="OhBoi.API" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <h3>Easy and free access for everybody, everywhere, anytime.</h3>
    <p>If you're not developing an integration with this website you can ignore this page and pretend it doesn't even exists.</p>
    <p><%: ConfigurationManager.AppSettings["AppName"] %> offers a simple interface anyone can use to upload Battlescribe roster files (.ros and .rosz) of any game and get in return a temporary code that can be used to retrieve the content of the rosters in either json or xml formats.</p>
    <hr />

    <div class="accordion" id="accordionPanelsStayOpenExample">
        <div class="accordion-item">
            <h5 class="accordion-header" id="panelsStayOpen-headingOne">
                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="true" aria-controls="panelsStayOpen-collapseOne">
                    Uploading a Roster / Getting a code
                </button>
            </h5>
            <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse show" aria-labelledby="panelsStayOpen-headingOne">
                <div class="accordion-body">
                    This should be the first thing you do when interacting with <%: ConfigurationManager.AppSettings["AppName"] %>. The only thing you have to do is to <code>POST</code> a file to <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx</code>.<br />
                    If the upload was successful the service will answer with a <code>Status Code 200</code>, <code>ContentType plain/text</code> and the roster <code>code</code> in the response body.<br />
                    Otherwise, the service will answer with a <code>Status Code 501</code>, <code>ContentType plain/text</code> and the error details in the reponse body.<br />
                    <br />
                    <div class="p-3 bg-light border rounded-3">
                        <strong>Limitations:</strong> although there are no limitations on the amount or the frequency you can upload files to the service, please be aware that you can only upload <code>1</code> file. Also, only Battlescribe's <code>.rosz</code> and <code>.ros</code> files can be uploaded, anything else will be discarded and an error will be returned.<br/>
                        Uploaded files are not stored on the server, if you lose your <code>code</code> you'll have to upload the file again. Finally, roster <code>codes</code> are valid only for <code><%: ConfigurationManager.AppSettings["MemoryDuration"] %> minutes</code> after which they'll expire and won't work anymore.
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-item">
            <h5 class="accordion-header" id="panelsStayOpen-headingTwo">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseTwo" aria-expanded="false" aria-controls="panelsStayOpen-collapseTwo">
                    Retrieving a Roster: JSON
                </button>
            </h5>
            <div id="panelsStayOpen-collapseTwo" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingTwo">
                <div class="accordion-body">
                    Getting a roster in <code>JSON</code> format is as easy as performing a <code>GET</code> request against <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx?code=[ROSTERCODE]</code> where <code>[ROSTERCODE]</code> is obviously the <code>code</code> you got after uploading a file to <%: ConfigurationManager.AppSettings["AppName"] %>. You can even try to open the url using any browser if you so wish: the address will be available and accessible an unlimited amount of times for <code><%: ConfigurationManager.AppSettings["MemoryDuration"] %> minutes</code> after which the <code>code</code> will expire.<br />
                    If the <code>code</code> is valid, the service will answer with a <code>Status Code 200</code>, <code>ContentType plain/text</code> and a json as the response body.<br />
                    It is also possible to request the json file as a <code>ContentType application/json</code> by adding <code>formatted=true</code> as an extra parameter to the request.
                    <div class="p-3 bg-light border rounded-3">
                        <strong>Examples:</strong> Assume the roster <code>code</code> is <code>fakecode123</code>.<br />
                        Simple plain/text retrieval: <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx?code=fakecode123</code><br />
                        Advanced application/json retrieval: <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx?code=fakecode123&formatted=true</code>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-item">
            <h5 class="accordion-header" id="panelsStayOpen-headingThree">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseThree" aria-expanded="false" aria-controls="panelsStayOpen-collapseThree">
                    Retrieving a Roster: XML
                </button>
            </h5>
            <div id="panelsStayOpen-collapseThree" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingThree">
                <div class="accordion-body">
                    Getting a roster in <code>XML</code> format is as easy as performing a <code>GET</code> request against <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx?code=[ROSTERCODE]&type=xml</code> where <code>[ROSTERCODE]</code> is obviously the <code>code</code> you got after uploading a file to <%: ConfigurationManager.AppSettings["AppName"] %>. You can even try to open the url using any browser if you so wish: the address will be available and accessible an unlimited amount of times for <code><%: ConfigurationManager.AppSettings["MemoryDuration"] %> minutes</code> after which the <code>code</code> will expire.<br />
                    If the <code>code</code> is valid, the service will answer with a <code>Status Code 200</code>, <code>ContentType plain/text</code> and the original xml file as the response body.<br />
                    It is also possible to request the json file as a <code>ContentType application/xml</code> by adding <code>formatted=true</code> as an extra parameter to the request.
                    <div class="p-3 bg-light border rounded-3">
                        <strong>Examples:</strong> Assume the roster <code>code</code> is <code>fakecode123</code>.<br />
                        Simple plain/text retrieval: <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx?code=fakecode123&type=xml</code><br />
                        Advanced application/json retrieval: <code><%: ConfigurationManager.AppSettings["BaseUrl"] %>FileHandler.ashx?code=fakecode123&type=xml&formatted=true</code>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-item">
            <h5 class="accordion-header" id="panelsStayOpen-headingFour">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseFour" aria-expanded="false" aria-controls="panelsStayOpen-collapseFour">
                    Common errors and how to fix them
                </button>
            </h5>
            <div id="panelsStayOpen-collapseFour" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingFour">
                <div class="accordion-body">
                    <strong>Generic errors:</strong>
                    <ul>
                        <li><code>501 - Invalid Operation</code>: Only <code>GET</code> and <code>POST</code> requests can be made against the service. Please make sure you're using the correct request type.</li>
                        <li><code>500 - Unknown Error: [ERROR MESSAGE]</code>: This is most likely not your fault and something wrong is happening on our side. Please follow the <a runat="server" href="~/Contacts">contact page</a> and reach out the website administrator with the error details.</li>
                    </ul>
                    <strong>[POST] While uploading a roster:</strong>
                    <ul>
                        <li><code>501 - Please upload at least a file</code>: As the message says, you need to upload a file if... you want to upload a file! If you got this error while trying to retrieve a roster, please make sure to use a <code>GET</code> request instead.</li>
                        <li><code>501 - Only one file per time can be uploaded</code>: There's no limit to the amount of files you can upload to the service, but you can only upload one at a time.</li>
                        <li><code>501 - Only .rosz and .ros files are allowed</code>: Please make sure that the file you're uploading comes from BattleScribe and it's in either rosz or ros format.</li>
                    </ul>
                    <strong>[GET] While retrieving a roster:</strong>
                    <ul>
                        <li><code>500 - Please provide a Roster ID</code>: Make sure that the request url has been properly formatted! If you're getting this error while trying to upload a roster file, make sure to make a <code>POST</code> request instead!</li>
                        <li><code>500 - The provided Roster ID is either invalid or expired</code>: Make sure that the request url has been properly formatted and that the provided roster code is correct! Also, don't forget that a roster code provided after an upload is only valid for <code><%: ConfigurationManager.AppSettings["MemoryDuration"] %> minutes</code>, maybe too much time has passed?</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
