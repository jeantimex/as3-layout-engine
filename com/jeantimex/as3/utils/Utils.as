package com.jeantimex.as3.utils {
	
	/**
	 * jeantime utility class
	 * 
	 * @author Yong Su
	 * @date 09/30/2012
	 */
	public class Utils {
		
		/**
		 * Remove an element from an array
		 * 
		 * @param arr
		 * @param value
		 * @return 
		 */
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