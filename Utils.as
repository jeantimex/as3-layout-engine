package
{
	public class Utils
	{
		public static function arraySplice( arr:Array, value:* ): Array {
			for ( var i:int = arr.length - 1; i >= 0; --i ) {
				if ( arr[i] === value ) {
					arr.splice( i, 1 );
				}
			}
			return arr;
		}
	}
}