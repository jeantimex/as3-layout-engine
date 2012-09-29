package
{
	import flash.display.MovieClip;
	
	public class layout extends MovieClip
	{
		public var grid:Grid;
		private var initPositions:Array = [ { x:0, y:0 }, { x:300, y:160 }, {x:600, y:320} ];
		
		/**
		 * Constructor
		 */
		public function layout()
		{
			for (var i:int = 0; i < initPositions.length; ++i) {
				var block:Block = new Block();
				
				block.init( {
					id: String( i ),
					x: initPositions[i].x,
					y: initPositions[i].y
				} );
				
				grid.addBlock( block );
			}
			
		}
	}
}