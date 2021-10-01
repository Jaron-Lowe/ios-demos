# demos-dateformatter-performance
Used to show Jr. devs the performance impact of different approaches to parsing and operating on model dates in bulk.

Runs 4 tests to parse dates from a list of 10,000 models:
1. Computed Properties, Unshared DateFormatter
2. Computed Properties, Shared DateFormatter
3. Stored Properties, Unshared DateFormatter
4. Stored Properties, Shared DateFormatter

<img src="/Screenshot.png" width="300"/>

## Topics
#DateFormatter #ComputedProperties #StoredProperties #DispatchGroup
