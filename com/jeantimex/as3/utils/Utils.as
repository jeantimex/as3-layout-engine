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
		 * @param array The host array
		 * @param value The value that is going to be removed
		 * @return The modified array
		 */
		public static function arraySplice( array:Array, value:* ): Array {
			for ( var i:int = array.length - 1; i >= 0; --i ) {
				if ( array[i] === value ) {
					array.splice( i, 1 );
				}
			}
			return array;
		}
	}
}