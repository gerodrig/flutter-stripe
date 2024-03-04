part of 'helpers.dart';

//? Show loading
void showLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
            title: Text('Please Wait...'),
            content: LinearProgressIndicator(),
          ));
}

void showAlert(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              MaterialButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
}
