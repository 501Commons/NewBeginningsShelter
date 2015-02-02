public class DuplicatedDataException extends Exception{
	public DuplicatedDataException(String source, String target, String moreInfo) {
		this.setMessage('This '+source+' is already linked to the '+ target + '. '+(moreInfo == null?'':moreInfo));
	}
}