import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
  id: root
  width: 960; height: 600; visible: true
  title: "Naiscorp Facility Manager"

  StackView {
    id: stack
    anchors.fill: parent
    initialItem: "qrc:/Login.qml"
    
    // Custom transitions for better UX
    pushEnter: Transition {
      PropertyAnimation {
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.OutCubic
      }
      PropertyAnimation {
        property: "y"
        from: 50
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
      }
    }
    
    pushExit: Transition {
      PropertyAnimation {
        property: "opacity"
        from: 1
        to: 0.3
        duration: 300
        easing.type: Easing.OutCubic
      }
    }
    
    popEnter: Transition {
      PropertyAnimation {
        property: "opacity"
        from: 0.3
        to: 1
        duration: 300
        easing.type: Easing.OutCubic
      }
    }
    
    popExit: Transition {
      PropertyAnimation {
        property: "opacity"
        from: 1
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
      }
      PropertyAnimation {
        property: "y"
        from: 0
        to: -50
        duration: 300
        easing.type: Easing.OutCubic
      }
    }
    
    replaceEnter: Transition {
      PropertyAnimation {
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.OutCubic
      }
      PropertyAnimation {
        property: "scale"
        from: 0.95
        to: 1
        duration: 400
        easing.type: Easing.OutCubic
      }
    }
    
    replaceExit: Transition {
      PropertyAnimation {
        property: "opacity"
        from: 1
        to: 0
        duration: 400
        easing.type: Easing.OutCubic
      }
      PropertyAnimation {
        property: "scale"
        from: 1
        to: 1.05
        duration: 400
        easing.type: Easing.OutCubic
      }
    }
    
    // Handle navigation signals from current item
    Connections {
      target: stack.currentItem
      ignoreUnknownSignals: true
      
      function onSignupRequested() {
        console.log("Navigation: Login -> Signup")
        stack.push("qrc:/Signup.qml")
      }
      
      function onLoggedIn() {
        console.log("Navigation: Login -> Dashboard")
        stack.replace("qrc:/Dashboard.qml")
      }
      
      function onBackToLogin() {
        console.log("Navigation: Signup -> Login")
        if (stack.depth > 1) {
          stack.pop()
        } else {
          // Fallback: replace with login
          stack.replace("qrc:/Login.qml")
        }
      }
      
      function onLogout() {
        console.log("Navigation: Dashboard -> Login")
        stack.replace("qrc:/Login.qml")
      }
    }
  }
}
