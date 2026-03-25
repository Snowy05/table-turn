# tableturn_project0

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Just notes here:

how to get a document etc 

--
// Fetch user data from Firestore and display it
      body: FutureBuilder<DocumentSnapshot>(  -- here using future builder to get all data ready
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(), --- selecting the collection and by the document uid in firestore

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { --- loading and etc
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Failed to load user data')); -- for failure
          }
          final appUser = AppUser.fromMap(snapshot.data!.data() as Map<String, dynamic>, snapshot.data!.id); -- here getting the actual data we can work with. now can call them with the parameter AppUser.name forexample 



