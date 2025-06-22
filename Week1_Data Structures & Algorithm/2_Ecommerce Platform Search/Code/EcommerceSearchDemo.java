public class EcommerceSearchDemo {

    static class Product {
        int productId;
        String productName;
        String category;

        public Product(int productId, String productName, String category) {
            this.productId = productId;
            this.productName = productName;
            this.category = category;
        }

        public void display() {
            System.out.println("ID: " + productId + ", Name: " + productName + ", Category: " + category);
        }
    }

    public static Product linearSearch(Product[] products, int targetId) {
        for (Product p : products) {
            if (p.productId == targetId) {
                return p;
            }
        }
        return null;
    }

    public static Product binarySearch(Product[] products, int targetId) {
        for (int i = 0; i < products.length - 1; i++) {
            for (int j = 0; j < products.length - i - 1; j++) {
                if (products[j].productId > products[j + 1].productId) {
                    Product temp = products[j];
                    products[j] = products[j + 1];
                    products[j + 1] = temp;
                }
            }
        }

        int low = 0, high = products.length - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            if (products[mid].productId == targetId) {
                return products[mid];
            } else if (products[mid].productId < targetId) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        Product[] products = {
            new Product(105, "Laptop", "Electronics"),
            new Product(102, "Shoes", "Footwear"),
            new Product(109, "Watch", "Accessories"),
            new Product(101, "Phone", "Electronics"),
            new Product(108, "Bag", "Travel")
        };

        System.out.println("Binary Search for ID 109:");
        Product result1 = binarySearch(products.clone(), 109);
        if (result1 != null) result1.display();
        else System.out.println("Product not found.");

        System.out.println("\nLinear Search for ID 102:");
        Product result2 = linearSearch(products, 102);
        if (result2 != null) result2.display();
        else System.out.println("Product not found.");

        System.out.println("\nBinary Search for ID 110:");
        Product result3 = binarySearch(products.clone(), 110);
        if (result3 != null) result3.display();
        else System.out.println("Product not found.");
    }
}
