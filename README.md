# KNeighbors 

KDTree based KNeighborsRegressor. Inspired by scikit-learn.

# Example
```swift
let features = [[2.0, 3.0, 1.0], [5.0, 4.0, 2.0], [9.0, 6.0, 3.0], [4.0, 7.0, 4.0], [8.0, 1.0, 5.0], [7.0, 2.0, 6.0]]
let targets = [4.0, 3.0, 2.0, 1.0, 5.0, 6.0]
let input = [9.0, 2.0, 3.0]
let model = KNeighborsRegressor<Double>()
model.fit(xRows: features, y: targets)
let predictions = model.predict(xRows: [input])
```
