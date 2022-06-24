<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="OhBoi._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div id="upbox" class="p-5 mb-4 bg-light border  rounded-3" style="position: relative">
        <h1><%: ConfigurationManager.AppSettings["AppName"] %></h1>
        <p class="lead">All-in-one roster management solution for Battlescribe to Table Top Simulator.</p>
        <p>Drag & Drop or upload any <span class="badge rounded-pill bg-secondary">.rosz</span> or <span class="badge rounded-pill bg-secondary">.ros</span> files from Battlescribe to get the roster code.</p>

        <div id="upstatus" class="my-3 p-3 bg-body rounded shadow-sm" style="display: none;">
            <h6 class="border-bottom pb-2 mb-0">Uploaded Files <span class="fw-light"> - click on the squares to copy to clipboard!</span></h6>
            <span id="upfiles"></span>
            
            <small class="d-block text-end mt-3">
                <a href="javascript:closeUpStatus()">Close</a>
            </small>
        </div>
        <p style="margin-top: 15px;">
            <input type="file" id="hiddenUpload" style="display: none;" />
            <input type="button" id="upload" class="btn btn-primary btn-lg" value="Upload File &raquo;" />
        </p>
        <div id="dragging" style="position: absolute; top: 0; right: 0; bottom: 0; left: 0; background-color: #347ab7e6; display: none; justify-content: center; align-items: center;">
            <h1>Drop files here</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Kill Team</h2>
            <p>With plenty of mods, automation and integrations, Kill Team on TTS offers an over the (table)top playing experience!</p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="https://steamcommunity.com/sharedfiles/filedetails/?id=2574389665">KT Base Table &raquo;</a></p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="#">OhBoi... Kill! &raquo;</a></p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="https://steamcommunity.com/sharedfiles/filedetails/?id=2577079549">KT Map Collection &raquo;</a></p>
            <p>If you're looking for the classic mods and tools instead:</p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="https://steamcommunity.com/sharedfiles/filedetails/?id=2614731381">KT Command Node &raquo;</a></p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="https://datateam.app/">Data Team &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Warcry</h2>
            <p>Implementing a system built on top of the Kill Team mods, playing Warcry has never been easier!</p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="#">Warcry Base Table &raquo;</a></p>
            <p><a class="btn btn-outline-secondary" target="_blank" href="#">OhBoi... Cry! &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Other Games</h2>
            <p>Even if this website has been designed keeping Kill Team and Warcry in mind, any Battlescribe-based TTS modding community can access and build on top of its services.</p>
        </div>
    </div>

</asp:Content>


<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <template id="uploadedFileTemplate">
        <div id="row_{FID}" class="d-flex text-muted pt-3">
            <svg id="stat_svg_{FID}" class="bd-placeholder-img flex-shrink-0 me-2 rounded spinner-grow" width="32" height="32" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="{STATUS}" preserveAspectRatio="xMidYMid slice" focusable="false">
                <title id="stat_title_{FID}">{STATUS}</title>
                <rect id="stat_rect_{FID}" width="100%" height="100%" fill="{FILL}"></rect>
                <text id="stat_{FID}" x="50%" y="50%" fill="{FILL}" dy=".3em">{STATUS}</text>
            </svg>

            <p class="pb-3 mb-0 small lh-sm border-bottom">
                <strong id="ret_fname_{FID}" class="d-block text-gray-dark">{FILENAME}</strong>
                <span id="ret_{FID}">Uploading...</span>
            </p>
        </div>
    </template>


    <template id="badgeCNP">
        <span class="badge rounded-pill bg-secondary">Unknown Game</span>
    </template>
    <template id="badgeWKT">
        <span class="badge rounded-pill bg-orange">Kill Team</span>
    </template>
    <template id="badgeCRY">
        <span class="badge rounded-pill bg-error">Warcry</span>
    </template>


    <script type="text/javascript">
        var selectedFiles = [];

        $(document).ready(function () {
            var box;
            box = document.getElementById("upbox");
            box.addEventListener("dragenter", OnDragEnter, false);
            box.addEventListener("dragover", OnDragOver, false);
            box.addEventListener("drop", OnDrop, false);
            box.addEventListener("dragend", OnDragEnd, false);
        });

        function OnDragEnter(e) {
            document.getElementById("dragging").style.display = "flex";

            e.stopPropagation();
            e.preventDefault();
        }

        function OnDragOver(e) {
            e.stopPropagation();
            e.preventDefault();
        }

        function OnDrop(e) {
            e.stopPropagation();
            e.preventDefault();

            document.getElementById("dragging").style.display = "none";

            selectedFiles = selectedFiles.concat(Array.from(e.dataTransfer.files));
            ProcessSelectedFiles();
        }

        function OnDragEnd(e) {
            e.stopPropagation();
            e.preventDefault();

            document.getElementById("dragging").style.display = "none";
        }

        $("#upload").click(function () {
            $("#hiddenUpload").click();
        });

        $("#hiddenUpload").on("change", function (e) {
            selectedFiles = selectedFiles.concat(Array.from($(this)[0].files));
            ProcessSelectedFiles();
        });

        function ProcessSelectedFiles() {
            if (selectedFiles.length <= 0)
                return;

            $("#upstatus").css("display", "block");

            var template = $("#uploadedFileTemplate")[0].innerHTML;
            for (var index = 0; index < selectedFiles.length; index++) {
                if (selectedFiles[index] == null) continue;

                var currTemplate = template.replaceAll("{FILENAME}", selectedFiles[index].name);
                currTemplate = currTemplate.replaceAll("{FILL}", "var(--bs-orange)");
                currTemplate = currTemplate.replaceAll("{FID}", index.toString());
                currTemplate = currTemplate.replaceAll("{STATUS}", "Uploading");
                
                $("#upfiles").html($("#upfiles").html() + currTemplate);
            }           

            for (var index = 0; index < selectedFiles.length; index++) {
                if (selectedFiles[index] == null) continue;
                UploadFile(index);
            }
        }

        function UploadFile(index) {
            var data = new FormData();
            data.append(selectedFiles[index].name, selectedFiles[index]);
            $.ajax({
                type: "POST",
                url: "FileHandler.ashx",
                contentType: false,
                processData: false,
                data: data,
                success: function (result) {
                    $("#stat_svg_" + index).removeClass("spinner-grow");
                    $("#stat_rect_" + index).attr("fill", "var(--bs-green)");
                    $("#stat_" + index).attr("fill", "var(--bs-green)");

                    $("#stat_title_" + index).html("Success");
                    $("#stat_svg_" + index).attr("aria-label", "Success");
                    $("#stat_" + index).html("Success");

                    $("#ret_" + index).html(result);

                    $("#stat_svg_" + index).attr("onclick", "copyTextToClipboard('" + result + "')");

                    var badge = $("#badge" + result.substring(0, 3))[0].innerHTML;
                    $("#ret_fname_" + index).html($("#ret_fname_" + index).html() + badge);

                    selectedFiles[index] = null;
                },
                error: function (xhr) {
                    $("#stat_svg_" + index).removeClass("spinner-grow");
                    $("#stat_rect_" + index).attr("fill", "var(--bs-red)");
                    $("#stat_" + index).attr("fill", "var(--bs-red)");

                    $("#stat_title_" + index).html("Failed");
                    $("#stat_svg_" + index).attr("aria-label", "Failed");
                    $("#stat_" + index).html("Failed");

                    if (xhr.status == 501)
                        $("#ret_" + index).html(xhr.responseText);
                    else
                        $("#ret_" + index).html("Unexpected Error!");

                    selectedFiles[index] = null;
                }
            });
        }

        function closeUpStatus() {
            $("#upfiles").html("");
            $("#upstatus").css("display", "none")
        }

        function fallbackCopyTextToClipboard(text) {
            var textArea = document.createElement("textarea");
            textArea.value = text;

            // Avoid scrolling to bottom
            textArea.style.top = "0";
            textArea.style.left = "0";
            textArea.style.position = "fixed";

            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();

            try {
                var successful = document.execCommand('copy');

                if (!successful) {
                    alert("Couldn't copy the code.");
                }
            } catch (err) {
                alert("Couldn't copy the code.");
            }

            document.body.removeChild(textArea);
        }

        function copyTextToClipboard(text) {
            text = text.replaceAll(' ', '%20');
            if (!navigator.clipboard) {
                fallbackCopyTextToClipboard(text);
                return;
            }
            navigator.clipboard.writeText(text).then(function () {
            }, function (err) {
                alert("Couldn't copy the code.");
            });
        }

    </script>
</asp:Content>
