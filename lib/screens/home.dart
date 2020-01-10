import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../config/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Apps'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMovie()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Movie>>(
        future: getMovie(new http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new MovieList(movie: snapshot.data)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movie;
  MovieList({Key key, this.movie}) : super(key: key);
  // ignore: non_constant_identifier_names
  Card MovieGrid(Movie movie) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 12.0,
              child: Image.asset(
                movie.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    movie.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFD73C29),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Text(
                    movie.description,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () => {updateRate(movie.id)},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      primary: true,
      crossAxisCount: 2,
      padding: EdgeInsets.all(1.0),
      childAspectRatio: 8.0 / 9.0,
      children: List.generate(movie.length, (index) {
        return MovieGrid(movie[index]);
      }),
    );
  }
}

class NewMovie extends StatefulWidget {
  NewMovie({Key key}) : super(key: key);

  _NewMoviePageState createState() => _NewMoviePageState();
}

class _NewMoviePageState extends State<NewMovie> {
  File _image;
  TextEditingController movieNameController = new TextEditingController();
  TextEditingController movieDescription = new TextEditingController();

  Future imageGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('New Movie'),
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextField(
              controller: movieNameController,
              decoration: InputDecoration(hintText: 'Movie Name'),
            ),
            TextField(
              controller: movieDescription,
              decoration: InputDecoration(hintText: 'Movie Description'),
            ),
            RaisedButton(
              onPressed: imageGallery,
              child: Text(
                'Choose Image',
              ),
            ),
            SizedBox(width: 10.0),
            RaisedButton(
                child: Text(
                  "Add Movie",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: () {
                  final body = {
                    "name": movieNameController.text,
                    "description": movieDescription.text,
                    "image": _image != null
                        ? 'data:image/png;base64,' +
                            base64Encode(_image.readAsBytesSync())
                        : ''
                  };
                  addMovie(body);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
