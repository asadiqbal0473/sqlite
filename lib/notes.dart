class NotesModel{

 final int? id;
 final String? title;
 final int? age;
 final String? description;
 final String? email;

 NotesModel({this.id,this.title,this.age,this.email,this.description});
 NotesModel.fromMap(Map<String,dynamic> res):
 id = res['id'],
 title = res['title'],
 age = res['age'],
 description = res['description'],
 email = res['email'];

 Map <String,Object?> toMap(){
   return{
     "id": id,
     "age" :age,
     "title": title,
     "description": description,
     "email":email,
   };

 }





}