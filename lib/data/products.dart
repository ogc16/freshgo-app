import '../models/product.dart';

const Map<String, List<Product>> products = {
  'groceries': [
    Product(id: 1, name: 'Fresh Tomatoes', unit: '1kg bag', price: 3500, emoji: '\u{1F345}', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFF5F5'),
    Product(id: 2, name: 'Cooking Oil', unit: '2L bottle', price: 14500, emoji: '\u{1FAF9}', tag: 'Essential', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 3, name: 'Basmati Rice', unit: '5kg bag', price: 28000, emoji: '\u{1F35A}', tag: 'Best Seller', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F5F9FF'),
    Product(id: 4, name: 'Red Onions', unit: '1kg', price: 2500, emoji: '\u{1F9C5}', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFF5F0'),
    Product(id: 5, name: 'Whole Bread', unit: '700g loaf', price: 5500, emoji: '\u{1F35E}', tag: 'Baked Today', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF8F0'),
    Product(id: 6, name: 'Farm Eggs', unit: 'Tray of 30', price: 18000, emoji: '\u{1F95A}', tag: 'Farm Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FAFFF5'),
    Product(id: 7, name: 'Sweet Bananas', unit: '1 bunch', price: 3000, emoji: '\u{1F34C}', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFFFF0'),
    Product(id: 8, name: 'Sugar (2kg)', unit: '2kg bag', price: 8500, emoji: '\u{1F36C}', tag: 'Essential', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF9F5'),
  ],
  'food': [
    Product(id: 9, name: 'Chicken Biryani', unit: '1 plate', price: 12000, emoji: '\u{1F35B}', tag: 'Hot & Ready', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF8F0'),
    Product(id: 10, name: 'Rolex (Ugandan)', unit: '2 eggs', price: 4000, emoji: '\u{1F30F}', tag: 'Street Fave', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F8'),
    Product(id: 11, name: 'Matoke Stew', unit: '1 portion', price: 8000, emoji: '\u{1F372}', tag: 'Local', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
    Product(id: 12, name: 'Pork Muchomo', unit: '6 sticks', price: 10000, emoji: '\u{1F362}', tag: 'Grilled', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F5'),
    Product(id: 13, name: 'Samosa (4pcs)', unit: '4 pieces', price: 4000, emoji: '\u{1F95F}', tag: 'Crispy', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 14, name: 'Fresh Juice', unit: '500ml', price: 5000, emoji: '\u{1F964}', tag: 'Cold', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0F9FF'),
    Product(id: 15, name: 'Pilau Rice', unit: '1 plate', price: 9000, emoji: '\u{1F35C}', tag: 'Spicy', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFAF0'),
    Product(id: 16, name: 'Mandazi (6pcs)', unit: '6 pieces', price: 3000, emoji: '\u{1F369}', tag: 'Freshly Made', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FAFFF8'),
  ],
  'gas': [
    Product(id: 17, name: '6kg Gas Cylinder', unit: 'Full cylinder', price: 85000, emoji: '\u{1F534}', tag: 'Cooking Gas', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F5'),
    Product(id: 18, name: '13kg Cylinder', unit: 'Full cylinder', price: 165000, emoji: '\u{1F7E0}', tag: 'Large Size', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF8F0'),
    Product(id: 19, name: 'Gas Refill 6kg', unit: 'Refill only', price: 55000, emoji: '\u{26FD}', tag: 'Refill', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
    Product(id: 20, name: 'Gas Refill 13kg', unit: 'Refill only', price: 110000, emoji: '\u{1F525}', tag: 'Refill', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
  ],
  'water': [
    Product(id: 21, name: '20L Jerry Can', unit: 'Jerry can refill', price: 2000, emoji: '\u{1FAA3}', tag: 'Refill', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0F9FF'),
    Product(id: 22, name: '10L Bottle', unit: 'Sealed bottle', price: 5500, emoji: '\u{1F4A7}', tag: 'Sealed', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0FAFF'),
    Product(id: 23, name: '5L Bottle', unit: 'Sealed bottle', price: 3000, emoji: '\u{1F376}', tag: 'Sealed', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0FAFF'),
    Product(id: 24, name: '500ml \u00D7 12 Pack', unit: 'Crate', price: 14400, emoji: '\u{1F9CA}', tag: 'Chilled', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFFD'),
  ],
};

List<Product> get allProducts =>
    products.values.expand((list) => list).toList();

const Map<String, Map<String, String>> categoryMeta = {
  'groceries': {'label': 'Groceries', 'emoji': '\u{1F966}', 'color': '#EAF5EC'},
  'food': {'label': 'Food', 'emoji': '\u{1F35B}', 'color': '#FFF3E0'},
  'gas': {'label': 'Gas', 'emoji': '\u{1F525}', 'color': '#FFF0F0'},
  'water': {'label': 'Water', 'emoji': '\u{1F4A7}', 'color': '#E3F2FD'},
};
