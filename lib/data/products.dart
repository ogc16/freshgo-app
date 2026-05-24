import '../models/product.dart';

const _url = 'https://images.unsplash.com/photo-';
const _ph = 'https://picsum.photos/seed/';

const Map<String, List<Product>> products = {
  'groceries': [
    Product(id: 1, name: 'Fresh Tomatoes', unit: '1kg bag', price: 3500, emoji: '\u{1F345}', imageUrl: '${_url}1592924357228-91a4daadcfea?w=300&h=300&fit=crop', localImage: 'assets/images/products/tomatoes.jpg', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFF5F5'),
    Product(id: 2, name: 'Cooking Oil', unit: '2L bottle', price: 14500, emoji: '\u{1FAF9}', imageUrl: '${_url}1474979266404-7eaacbcd87c5?w=300&h=300&fit=crop', localImage: 'assets/images/products/oil.jpg', tag: 'Essential', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 3, name: 'Basmati Rice', unit: '5kg bag', price: 28000, emoji: '\u{1F35A}', imageUrl: '${_url}1586201375761-83865001e31c?w=300&h=300&fit=crop', localImage: 'assets/images/products/rice.jpg', tag: 'Best Seller', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F5F9FF'),
    Product(id: 4, name: 'Red Onions', unit: '1kg', price: 2500, emoji: '\u{1F9C5}', imageUrl: '${_ph}onions/300/300', localImage: 'assets/images/products/onions.jpg', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFF5F0'),
    Product(id: 5, name: 'Whole Bread', unit: '700g loaf', price: 5500, emoji: '\u{1F35E}', imageUrl: '${_ph}bread/300/300', localImage: 'assets/images/products/bread.jpg', tag: 'Baked Today', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF8F0'),
    Product(id: 6, name: 'Farm Eggs', unit: 'Tray of 30', price: 18000, emoji: '\u{1F95A}', imageUrl: '${_url}1582722872445-44dc5f7e3c8f?w=300&h=300&fit=crop', localImage: 'assets/images/products/eggs.jpg', tag: 'Farm Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FAFFF5'),
    Product(id: 7, name: 'Sweet Bananas', unit: '1 bunch', price: 3000, emoji: '\u{1F34C}', imageUrl: '${_url}1603833665858-e61d17a86224?w=300&h=300&fit=crop', localImage: 'assets/images/products/bananas.jpg', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFFFF0'),
    Product(id: 8, name: 'Sugar (2kg)', unit: '2kg bag', price: 8500, emoji: '\u{1F36C}', imageUrl: '${_ph}sugar/300/300', localImage: 'assets/images/products/sugar.jpg', tag: 'Essential', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF9F5'),
    Product(id: 25, name: 'Irish Potatoes', unit: '1kg', price: 2500, emoji: '\u{1F954}', imageUrl: '${_ph}potatoes/300/300', localImage: 'assets/images/products/potatoes.jpg', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFF8F0'),
    Product(id: 26, name: 'Fresh Milk', unit: '1L', price: 4500, emoji: '\u{1F95B}', imageUrl: '${_ph}milk/300/300', localImage: 'assets/images/products/milk.jpg', tag: 'Chilled', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0FAFF'),
    Product(id: 27, name: 'Wheat Flour', unit: '2kg bag', price: 7500, emoji: '\u{1F9C6}', imageUrl: '${_url}1558961363-fa8fdf82db35?w=300&h=300&fit=crop', localImage: 'assets/images/products/flour.jpg', tag: 'Essential', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 28, name: 'Ripe Avocados', unit: '1kg', price: 4000, emoji: '\u{1F951}', imageUrl: '${_ph}avocados/300/300', localImage: 'assets/images/products/avocados.jpg', tag: 'Fresh', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF5'),
  ],
  'food': [
    Product(id: 9, name: 'Chicken Biryani', unit: '1 plate', price: 12000, emoji: '\u{1F35B}', imageUrl: '${_ph}biryani/300/300', localImage: 'assets/images/products/biryani.jpg', tag: 'Hot & Ready', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF8F0'),
    Product(id: 10, name: 'Rolex (Ugandan)', unit: '2 eggs', price: 4000, emoji: '\u{1F30F}', imageUrl: '${_url}1550547660-d9450f859349?w=300&h=300&fit=crop', localImage: 'assets/images/products/rolex.jpg', tag: 'Street Fave', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F8'),
    Product(id: 11, name: 'Matoke Stew', unit: '1 portion', price: 8000, emoji: '\u{1F372}', imageUrl: '${_url}1596797038530-2c107229654b?w=300&h=300&fit=crop', localImage: 'assets/images/products/matoke.jpg', tag: 'Local', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
    Product(id: 12, name: 'Pork Muchomo', unit: '6 sticks', price: 10000, emoji: '\u{1F362}', imageUrl: '${_url}1529193591184-b1d58069ecdd?w=300&h=300&fit=crop', localImage: 'assets/images/products/muchomo.jpg', tag: 'Grilled', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F5'),
    Product(id: 13, name: 'Samosa (4pcs)', unit: '4 pieces', price: 4000, emoji: '\u{1F95F}', imageUrl: '${_url}1601050690597-df0568f70950?w=300&h=300&fit=crop', localImage: 'assets/images/products/samosa.jpg', tag: 'Crispy', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 14, name: 'Fresh Juice', unit: '500ml', price: 5000, emoji: '\u{1F964}', imageUrl: '${_url}1622597467836-f3285f2131b8?w=300&h=300&fit=crop', localImage: 'assets/images/products/juice.jpg', tag: 'Cold', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0F9FF'),
    Product(id: 15, name: 'Pilau Rice', unit: '1 plate', price: 9000, emoji: '\u{1F35C}', imageUrl: '${_url}1555126634-323283e090fa?w=300&h=300&fit=crop', localImage: 'assets/images/products/pilau.jpg', tag: 'Spicy', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFAF0'),
    Product(id: 16, name: 'Mandazi (6pcs)', unit: '6 pieces', price: 3000, emoji: '\u{1F369}', imageUrl: '${_url}1558961363-fa8fdf82db35?w=300&h=300&fit=crop', localImage: 'assets/images/products/mandazi.jpg', tag: 'Freshly Made', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FAFFF8'),
    Product(id: 29, name: 'Whole Catfish', unit: '1 fish', price: 7000, emoji: '\u{1F41F}', imageUrl: '${_ph}catfish/300/300', localImage: 'assets/images/products/catfish.jpg', tag: 'Fresh Catch', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0F9FF'),
    Product(id: 30, name: 'Chapati (4pcs)', unit: '4 pieces', price: 3500, emoji: '\u{1F95F}', imageUrl: '${_ph}chapati/300/300', localImage: 'assets/images/products/chapati.jpg', tag: 'Hot & Ready', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 31, name: 'Beef Stew', unit: '1 portion', price: 11000, emoji: '\u{1F969}', imageUrl: '${_ph}beef-stew/300/300', localImage: 'assets/images/products/beef_stew.jpg', tag: 'Hearty', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F5'),
    Product(id: 32, name: 'Vegetable Rice', unit: '1 plate', price: 8500, emoji: '\u{1F35A}', imageUrl: '${_ph}veg-rice/300/300', localImage: 'assets/images/products/veg_rice.jpg', tag: 'Healthy', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
  ],
  'gas': [
    Product(id: 17, name: '6kg Gas Cylinder', unit: 'Full cylinder', price: 85000, emoji: '\u{1F534}', imageUrl: '${_ph}gas-cylinder/300/300', localImage: 'assets/images/products/gas_cylinder.jpg', tag: 'Cooking Gas', tagColor: '#FCE4EC', tagTxt: '#880E4F', bg: '#FFF5F5'),
    Product(id: 18, name: '13kg Cylinder', unit: 'Full cylinder', price: 165000, emoji: '\u{1F7E0}', imageUrl: '${_ph}gas-cylinder/300/300', localImage: 'assets/images/products/gas_cylinder.jpg', tag: 'Large Size', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFF8F0'),
    Product(id: 19, name: 'Gas Refill 6kg', unit: 'Refill only', price: 55000, emoji: '\u{26FD}', imageUrl: '${_ph}gas-refill/300/300', localImage: 'assets/images/products/gas_refill.jpg', tag: 'Refill', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
    Product(id: 20, name: 'Gas Refill 13kg', unit: 'Refill only', price: 110000, emoji: '\u{1F525}', imageUrl: '${_ph}gas-refill/300/300', localImage: 'assets/images/products/gas_refill.jpg', tag: 'Refill', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFF7'),
    Product(id: 33, name: 'Gas Stove (Single)', unit: '1 burner', price: 45000, emoji: '\u{1F525}', imageUrl: '${_ph}gas-stove/300/300', localImage: 'assets/images/products/gas_stove.jpg', tag: 'New Arrival', tagColor: '#FFF3D6', tagTxt: '#9A6800', bg: '#FFFBF0'),
    Product(id: 34, name: 'Gas Hose & Regulator', unit: '1 set', price: 15000, emoji: '\u{1F527}', imageUrl: '${_ph}gas-hose/300/300', localImage: 'assets/images/products/gas_hose.jpg', tag: 'Essential', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#FFF8F0'),
  ],
  'water': [
    Product(id: 21, name: '20L Jerry Can', unit: 'Jerry can refill', price: 2000, emoji: '\u{1FAA3}', imageUrl: '${_url}1548839140-29a749e1cf4d?w=300&h=300&fit=crop', localImage: 'assets/images/products/jerry_can.jpg', tag: 'Refill', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0F9FF'),
    Product(id: 22, name: '10L Bottle', unit: 'Sealed bottle', price: 5500, emoji: '\u{1F4A7}', imageUrl: '${_url}1548839140-29a749e1cf4d?w=300&h=300&fit=crop', localImage: 'assets/images/products/water_bottle.jpg', tag: 'Sealed', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0FAFF'),
    Product(id: 23, name: '5L Bottle', unit: 'Sealed bottle', price: 3000, emoji: '\u{1F376}', imageUrl: '${_url}1548839140-29a749e1cf4d?w=300&h=300&fit=crop', localImage: 'assets/images/products/water_bottle.jpg', tag: 'Sealed', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0FAFF'),
    Product(id: 24, name: '500ml \u00D7 12 Pack', unit: 'Crate', price: 14400, emoji: '\u{1F9CA}', imageUrl: '${_url}1548839140-29a749e1cf4d?w=300&h=300&fit=crop', localImage: 'assets/images/products/water_pack.jpg', tag: 'Chilled', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFFD'),
    Product(id: 35, name: 'Sparkling Water 330ml', unit: '1 bottle', price: 2500, emoji: '\u{1F377}', imageUrl: '${_ph}sparkling/300/300', localImage: 'assets/images/products/sparkling.jpg', tag: 'Chilled', tagColor: '#E3F2FD', tagTxt: '#0D5CA6', bg: '#F0FAFF'),
    Product(id: 36, name: 'Dispenser 18.9L', unit: 'Sealed bottle', price: 12000, emoji: '\u{1F4A6}', imageUrl: '${_url}1548839140-29a749e1cf4d?w=300&h=300&fit=crop', localImage: 'assets/images/products/dispenser.jpg', tag: 'Large', tagColor: '#E8F5EC', tagTxt: '#1C5C35', bg: '#F5FFFD'),
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
