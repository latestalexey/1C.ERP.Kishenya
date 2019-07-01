////////////////////////////////////////////////////////////////////////////////
// Подсистема "Поиск и удаление дублей".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты, в модулях менеджеров которых предусмотрена возможность параметризации 
// алгоритма поиска дублей с помощью экспортных процедур ПараметрыПоискаДублей, ПриПоискеДублей 
// и ВозможностьЗаменыЭлементов.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Поиск и удаление дублей". 
//                            В значении могут быть перечислены имена экспортных процедур:
//                            "ПараметрыПоискаДублей",
//                            "ПриПоискеДублей",
//                            "ВозможностьЗаменыЭлементов".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указана пустая строка, значит в модуле менеджера определены все процедуры.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), ""); // определены все процедуры
//   Объекты.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "ПараметрыПоискаДублей
//      |ПриПоискеДублей
//      |ВозможностьЗаменыЭлементов");
//
Процедура ПриОпределенииОбъектовСПоискомДублей(Объекты) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
