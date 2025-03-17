import sys
import random
from faker import Faker

fake = Faker()

def generate_sql(num_products: int, filename: str):
    categories = [fake.word().capitalize() for _ in range(10)]
    attributes = ['Colour', 'Size', 'Material', 'Weight', 'Brand']

    with open(filename, 'w') as file:
        # Insert categories
        file.write("-- Categories\n")
        for i, category in enumerate(categories, start=1):
            file.write(f"INSERT INTO categories (id, name, description) VALUES ({i}, '{category}', '{fake.sentence()}');\n")

        # Insert attributes
        file.write("\n-- Attributes\n")
        for i, attribute in enumerate(attributes, start=1):
            file.write(f"INSERT INTO attributes (id, name, description) VALUES ({i}, '{attribute}', '{fake.sentence()}');\n")

        # Insert products
        file.write("\n-- Products\n")
        for i in range(1, num_products + 1):
            sku = f"SKU-{fake.unique.bothify(text='???-####')}"
            name = fake.word().capitalize()
            description = fake.sentence()
            category_id = random.randint(1, len(categories))
            file.write(f"INSERT INTO products (id, sku, name, description, category_id) VALUES ({i}, '{sku}', '{name}', '{description}', {category_id});\n")

            # Insert attribute values
            for attr_id in range(1, len(attributes) + 1):
                value = fake.word()
                file.write(f"INSERT INTO attribute_values (attribute_id, product_id, value) VALUES ({attr_id}, {i}, '{value}');\n")

            # Insert variants
            variant_count = random.randint(1, 3)
            for v in range(1, variant_count + 1):
                variant_sku = f"{sku}-VAR-{v}"
                file.write(f"INSERT INTO variants (product_id, sku) VALUES ({i}, '{variant_sku}');\n")

            # Insert images
            image_url = fake.image_url()
            file.write(f"INSERT INTO images (product_id, url, alt_text) VALUES ({i}, '{image_url}', '{fake.sentence()}');\n")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python populate_pim_db.py <number_of_products> </path/to/file.sql>")
        sys.exit(1)

    num_products = int(sys.argv[1])
    file_sql = sys.argv[2]
    generate_sql(num_products, file_sql)

