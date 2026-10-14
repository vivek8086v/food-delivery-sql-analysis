# Data Dictionary

All data is synthetic. IDs are integer primary keys unless otherwise noted.

## customers.csv / customers
| Column | Meaning |
|---|---|
| customer_id | Unique customer identifier |
| customer_name | Synthetic display name |
| email | Unique synthetic email |
| city | Customer city |
| signup_date | Account signup date |
| customer_segment | Synthetic starter segment; independent of calculated repeat-order segment |

## restaurants.csv / restaurants
| Column | Meaning |
|---|---|
| restaurant_id | Unique restaurant identifier |
| restaurant_name | Synthetic restaurant name |
| city | Restaurant city |
| cuisine | Cuisine category |
| rating | Synthetic rating from 3.0 to 5.0 |
| is_active | 1 if marked active, otherwise 0 |

## products.csv / products
| Column | Meaning |
|---|---|
| product_id | Unique product identifier |
| restaurant_id | Restaurant that lists the product |
| product_name | Synthetic product name |
| category | Menu category |
| price | Listing price at generation time |
| is_available | 1 if marked available, otherwise 0 |

## orders.csv / orders
| Column | Meaning |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer who placed the order |
| restaurant_id | Restaurant receiving the order |
| order_datetime | Timestamp in 2025 |
| order_status | Delivered, Cancelled, Preparing, or On the way |
| delivery_minutes | Delivery duration; populated for delivered orders |
| delivery_fee | Fee associated with order |
| discount_amount | Synthetic discount amount |
| payment_method | UPI, Card, Cash, or Wallet |

## order_items.csv / order_items
| Column | Meaning |
|---|---|
| order_item_id | Unique line-item identifier |
| order_id | Related order |
| product_id | Related product |
| quantity | Units in the line item |
| unit_price | Unit price recorded on this line item |
