class Category{
  int id;
  String name;

  Category(this.id, this.name);

  static List<Category> getCategories(){
    return <Category>[
      Category(1,'Smece'),
      Category(2,'Otpad'),
      Category(3,'Drugo'),
    ];
  }
}