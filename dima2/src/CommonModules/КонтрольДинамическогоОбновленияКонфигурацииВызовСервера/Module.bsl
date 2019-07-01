////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контроль динамического обновления конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверить, что информационная база была обновлена динамически.
//
Функция КонфигурацияБДБылаИзмененаДинамически() Экспорт
	
	Возврат КонфигурацияБазыДанныхИзмененаДинамически()
	    Или СтандартныеПодсистемыСервер.РасширенияИзмененыДинамически();
	
КонецФункции

#КонецОбласти
