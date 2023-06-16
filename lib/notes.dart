
class notesmodel{
  late final int? id;
  late final int? age;
  late final String title;
  late final String description;
  late final String email;

  notesmodel({this.id,required this.title, this.age,required this.email,required this.description});

  notesmodel.fromMap(Map<String,dynamic> res):
        id= res['id'],
        title= res['title'],
        age= res['age'],
        email= res['email'],
  description= res['description'];

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'title':title,
      'age':age,
      'email':email,
      'description':description
    };
  }
}