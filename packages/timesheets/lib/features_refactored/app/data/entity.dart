abstract class Entity {
  Map<String, dynamic> toJSON();
  Entity fromJSON(Map<String, dynamic> json);
}
