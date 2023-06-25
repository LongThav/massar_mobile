class ElectronicModel {
    // bool successfully;
    int statusCode;
    List<Electronic> data;

    ElectronicModel({
        //  required this.successfully,
         this.statusCode = 200,
         this.data = const [],
    });

    factory ElectronicModel.fromJson(Map<String, dynamic> json) => ElectronicModel(
        // successfully: json["successfully"],
        statusCode: json["statusCode"],
        data: List<Electronic>.from(json["data"].map((x) => Electronic.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        // "successfully": successfully,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Electronic {
    int id;
    String name;
    String sellerName;
    String price;
    String? rate;
    String image;
    String? discountPrice;
    String? electronicId;
    DateTime createdAt;
    DateTime updatedAt;

    Electronic({
        this.id = 9,
        this.name = "no-name",
        this.sellerName = "no-sellerName",
        this.price = "no-price",
        this.rate = "no-rate",
        this.image = "no-image",
        this.discountPrice = "no-discountPrice",
        this.electronicId = "no-electronicId",
        required this.createdAt,
        required this.updatedAt,
    });

    factory Electronic.fromJson(Map<String, dynamic> json) => Electronic(
        id: json["id"],
        name: json["name"],
        sellerName: json["seller_name"],
        price: json["price"],
        rate: json["rate"],
        image: json["image"],
        discountPrice: json["discount_price"],
        electronicId: json["electronic_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "seller_name": sellerName,
        "price": price,
        "rate": rate,
        "image": image,
        "discount_price": discountPrice,
        "electronic_id": electronicId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
