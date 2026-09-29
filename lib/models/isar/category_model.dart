import 'package:isar_community/isar.dart';

part 'category_model.g.dart';

@collection
class CategoryItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String categoryId;

  @Index(unique: true)
  late String name;

  late String description;

  late int productCount;

  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;
}
