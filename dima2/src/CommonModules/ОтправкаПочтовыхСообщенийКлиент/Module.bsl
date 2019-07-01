
#Область ПрограммныйИнтерфейс

// Отправляет по электронной почте результат выполнения отчета.
//
// Параметры:
//  Отчет - УправляемаяФорма - форма отправляемого отчета.
//  ДополнительныеПараметры - Структура - дополнительные параметры для формирования письма:
//   * Вложения - Соответствие - описание дополнительных вложений для передачи по почте:
//     ** Ключ - Строка - адрес двоичных данных во временном хранилище.
//     ** Значение - Строка - имя файла.
//
Процедура ОтправитьОтчет(Отчет, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ТабличныйДокумент", Отчет.Результат);
	ПараметрыОтчета.Вставить("Заголовок"        , Отчет.Заголовок);
	
	КлючеваяОперация = "ОтправкаОтчетаПоЭлектроннойПочте";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	ПараметрыПисьма = ОтправкаПочтовыхСообщенийВызовСервера.ПараметрыЭлектронногоПисьмаДляОтчетов(ПараметрыОтчета,
		ДополнительныеПараметры);
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
	
КонецПроцедуры

#КонецОбласти
