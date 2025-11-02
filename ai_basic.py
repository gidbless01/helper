import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

# Step 1: Prepare Data
data = {
    'area': [1000, 1500, 2000, 2500, 3000],
    'bedrooms': [2, 3, 3, 4, 4],
    'price': [200000, 250000, 300000, 350000, 400000]
}
df = pd.DataFrame(data)

# Step 2: Split into train/test sets
X = df[['area', 'bedrooms']]
y = df['price']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Step 3: Train a model
model = LinearRegression()
model.fit(X_train, y_train)

# Step 4: Predict
area = 2300
bedrooms = 3
predicted_price = model.predict([[area, bedrooms]])
print(f"Predicted price for {area} sqft and {bedrooms} bedrooms: ${predicted_price[0]:,.2f}")
