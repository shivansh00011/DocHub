
# DocHub

DocHub is a collaborative document editing platform built using Flutter and Node.js. It allows users to create, view, and edit documents in real time. With Google OAuth integration, users can securely sign in, access their documents, and collaborate with others seamlessly.




### Features

**Secure Authentication:**
    Sign in with Google using OAuth.

**Document Management:** 
    View all created documents and create new ones effortlessly.

**Rich Text Editing:**
    Powered by **flutter_quill** for advanced text editing capabilities.

**Real-Time Collaboration:**
    Collaborate on documents with other users using socket connections. Share a unique link with others to enable live editing.

**Unique Document IDs:**
    Each document is assigned a unique ID for easy sharing and identification.     


### TechStack
**Flutter:** Rich UI for document creation and editing. Used flutter_quill for the text editor.


**Node.js:** Manages authentication and document APIs.
Handles real-time socket connections using socket.io.

**MongoDB:** Stores user documents and metadata.

**Google OAuth:** For secure sign-in functionality.




## Installation
### Prerequisites
Flutter SDK installed on your machine.

Node.js and npm installed.

MongoDB connection string (or a running MongoDB instance).

**Clone the repository:**

```bash
  git clone https://github.com/shivansh00011/DocHub.git  
  cd dochub  

```

**Setup Flutter project :**

Install dependencies:

```bash
flutter pub get   

```

Update the **constants.dart** file to configure your backend server's IP address. Replace your_ip_address with the appropriate local or deployed server IP address:

```bash
const String host = 'http://your_ip_address:3001';  

```

Run the app:

```bash
flutter run -d chrome --web-hostname localhost --web-port 3000   

```


**Setup Backend:**

Navigate to the backend directory:

```bash
cd server  

```
Install dependencies:

```bash
npm install   

```
Configure the database connection string in server/index.js:

```bash
const DB = "your_mongodb_connection_string";    

```

Start the backend server:

```bash
npm run dev      

```


### Usage

**Sign In:** Start the app and log in using your Google account.

**Document Management:** View existing documents on the main screen.
Create new documents with the "Create" button.

**Editing and Collaboration:** 

* Edit documents using the integrated text editor.

* Click the "Share" button to copy the document link.

* Share the link with collaborators for simultaneous editing.

### Project Video:



https://github.com/user-attachments/assets/a9a3eb24-4ab1-4606-b9d3-1468cb741c39




### Troubleshooting

* Check your backend server is running properly or not.

* If you encounter issues with the connection, verify that the IP address in constants.dart matches your server's address.

### Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to enhance the functionality or fix bugs.

