import SwiftUI

extension View {
	@inlinable
	/// Returns a `View` copy with restructured modifications made to it. Use to apply configuration changes to a `View`.
	/// - Parameter body: A closure used to modify a `View` struct
	/// - Returns: A copy of this `View` with the closure modifications made.
	public func restructured(_ body: (inout Self) -> Void) -> Self {
		var temp = self
		body(&temp)
		return temp
	}
}
