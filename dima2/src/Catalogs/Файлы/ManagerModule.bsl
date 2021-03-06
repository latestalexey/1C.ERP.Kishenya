#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Описание");
	РедактируемыеРеквизиты.Добавить("Редактирует");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	Если ВидФормы = "ФормаСписка" Тогда
		ТекущаяСтрока = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ТекущаяСтрока");
		Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.Файлы") И Не ТекущаяСтрока.Пустая() Тогда
			СтандартнаяОбработка = Ложь;
			ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока, "ВладелецФайла");
			Если ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
				Параметры.Вставить("Папка", ВладелецФайла);
				ВыбраннаяФорма = "Справочник.Файлы.Форма.Файлы";
			Иначе
				Параметры.Вставить("ВладелецФайла", ВладелецФайла);
				ВыбраннаяФорма = "Справочник.Файлы.Форма.ФормаСпискаПрисоединенныхФайлов";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

#КонецОбласти
