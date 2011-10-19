import QtQuick 1.1
import com.nokia.meego 1.0


Page{
    id: rootAuthenticationView
    property string authenticationUrl
    property bool webBrowserOpened: false
    signal cancelClicked()
    orientationLock: PageOrientation.LockPortrait



    Connections{
        target: flickrManager
        onAuthenticationRequired: rootAuthenticationView.state = ""
        onVerifierRequired: rootAuthenticationView.state = "verification";
        onVerificationFailure: {errorDialog.open(); codeInput.clear();}
    }

    QueryDialog {
         id: errorDialog
         titleText: "Error"
         message: "Authentication to Flickr failed! Let's try again..."
         rejectButtonText: "Ok"
         onRejected: rootAuthenticationView.state = ""
     }

    Rectangle{
        color: "black"
        anchors.fill: parent
    }

    Text{
        id: authTextTitle
        color:  "blue"
        text: "Authenticate to Flickr"
        font.pixelSize: settings.largeFontSize * 1.5
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: settings.mediumMargin
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column{
        id: authenticationInstructions
        anchors.centerIn: parent
        spacing:  settings.hugeMargin

        Label{
            id: instructionsText
            color:  "white"
            horizontalAlignment: Text.AlignJustify
            font.pixelSize: settings.largeFontSize
            width: settings.portrait? settings.pageWidth*0.8: settings.pageHeight*1.1
            text: "QuickFlickr needs to be authenticated to Flickr. " +
                  "Authentication will open N9's webbrowser. Follow the instructions in the browser.<br><br>" +
                  "Tap \'Go Flickr\' button to start authentication."
        }

        Button{
            id: button
            text: "Go Flickr"
            width: settings.buttonWidth
            onClicked: flickrManager.authenticate()
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


    Column{
        id: verifierCode
        property string verifierValue: code1.text + code2.text + code3.text
        onVerifierValueChanged: console.log("Verifier Value: "+verifierValue)
        anchors.centerIn: parent
        opacity: 0
        spacing: settings.largeMargin
        Label{
            width: parent.width
            color:  "white"
            font.pixelSize: settings.largeFontSize
            text: "Type the verification code from the Flickr webpage to below."
        }

        Component{
            id: line
            LineSeparator{
                color: "white"
                height:  5
                width: settings.largeMargin * 2
            }
        }

        Row{
            id: codeInput
            spacing: settings.mediumMargin
            function clear()
            {
                code1.text = "";
                code1.cursorPosition = 0;
                code2.text = "";
                code2.cursorPosition = 0;
                code3.text = "";
                code3.cursorPosition = 0;
            }

            DigitField{
                id: code1
            }
            Loader{ sourceComponent: line; anchors.verticalCenter: parent.verticalCenter }
            DigitField{
                id: code2
            }
            Loader{ sourceComponent: line; anchors.verticalCenter: parent.verticalCenter }
            DigitField{
                id: code3
            }
        }


        Button{
            id: verify
            text: "Verify"
            width: settings.buttonWidth
            onClicked: flickrManager.setVerifier(verifierCode.verifierValue)
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: (code1.acceptableInput && code2.acceptableInput && code3.acceptableInput)
        }
    }



    Image{
        source: "qrc:/gfx/d-pointer-logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }


    states: [
        /*
        State{
            name: "authenticating"

            PropertyChanges {
                target: verifierCode
                opacity: 0
            }
        },
        */
        State{
            name: "verification"
            PropertyChanges {
                target: authenticationInstructions
                opacity: 0
            }
            PropertyChanges {
                target: verifierCode
                opacity: 1
            }
        }

    ]

    transitions:  Transition {
        PropertyAnimation{properties:  "opacity"; duration: 500}
    }
}
