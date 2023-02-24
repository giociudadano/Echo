part of main;

class HomePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inputTitle = TextEditingController();
  final _inputContent = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Page',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 48,)
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextFormField(
                        controller: _inputTitle,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          hintText: 'Enter title',
                        ),
                        validator: (String? value) {
                          return _verifyTitle(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextFormField(
                        controller: _inputContent,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Content',
                          hintText: 'Enter additional information here.',
                        ),
                        validator: (String? value) {
                          return _verifyContent(value);
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _writePost(context, _inputTitle.text, _inputContent.text);
                      },
                      child: const Text('Write Data'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _logoutUser(context);
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was an error logging out your account. Please try again later."),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Logout Successful!"),
    ));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  void _writePost(BuildContext context, title, content) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");
      ref.push().update({
        'title': title,
        'content': content,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Post has been submitted!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was an error submitting your post. Please try again later."),
      ));
    }
  }

  _verifyTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  _verifyContent(String? value) {
    return null;
  }

}