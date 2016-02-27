library restaurant_router;

import 'package:angular/angular.dart';
void restaurantRouteInitializer(Router router, RouteViewFactory views){
  views.configure({
    'admin': ngRoute(
        path: '/admin',
        view: 'view/editMenuItem.html',
        mount: {
          'preview':ngRoute(
              path: '/preview',
              view: 'view/preview.html'),
          'edit-mode': ngRoute(
              path: '/edit/:category',
              view: 'view/editor.html'),
          'add-item': ngRoute(
              path: '/add',
              view: 'view/addMenuItem.html')
        }),
    'view': ngRoute(
        path: '/view',
        view: 'view/menuController.html'
        ),
    'kitchen': ngRoute(
        path: '/kitchen',
        view: 'view/kitchen.html'
        ),
    'register_table': ngRoute(
        path: '/table/:table_num',
        viewHtml: '<register-table></register-table>'),
    'logout': ngRoute(
        path: '/logout',
        viewHtml: '<logout></logout>'),
    'test': ngRoute(
        path: '/test',
        viewHtml: '<test></test>'),
    'default_page': ngRoute(
        defaultRoute: true,
        enter: (RouteEnterEvent e){
          router.activePath.forEach((e){
            print("Something to do with router : ${e}");
          });
          router.go('view', {});
        })
  });
}