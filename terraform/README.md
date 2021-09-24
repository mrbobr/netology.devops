
___
__Благодаря файлу .gitignore в текущем каталоге будут проигнорированы:__

1. Все скрытые вложенные каталоги .terraform  
2. Все файлы соответствующие маске вида

      *.tfstate  
      \*.tfstate.*  
      *.tfvars  
      *_override.tf  
      \*_override.tf.json*  
где * - соответствует 0 и более любых символов

3. Файлы  
   crash.log  
   override.tf  
   override.tf.json  
   .terraformrc  
   terraform.rc
___