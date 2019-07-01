////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейКлиентПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область ФункциональныеОпции

// Функция возвращает результат - можно ли работать с новостями.
// Это результат функциональной опции "РазрешенаРаботаСНовостями"
//   И доступны нужные роли
//   И это не внешний пользователь.
// 
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Булево.
//
Функция РазрешенаРаботаСНовостями() Экспорт

	Результат = ОбработкаНовостейВызовСервера.РазрешенаРаботаСНовостями();

	Возврат Результат;

КонецФункции

// Функция возвращает результат - можно ли работать с новостями текущему пользователю.
// Это результат функциональной опции "РазрешенаРаботаСНовостями"
//   И доступны нужные роли
//   И это не внешний пользователь
//   И задан параметр сеанса ТекущийПользователь (т.е. мы не зашли в базу с отключенным списком пользователей).
// 
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Булево.
//
Функция РазрешенаРаботаСНовостямиТекущемуПользователю() Экспорт

	Результат = ОбработкаНовостейВызовСервера.РазрешенаРаботаСНовостямиТекущемуПользователю();

	Возврат Результат;

КонецФункции

// Функция возвращает результат - можно ли работать с новостями через интернет.
// Это результат функциональной опции "РазрешенаРаботаСНовостямиЧерезИнтернет"
//   И доступны нужные роли
//   И это не внешний пользователь.
// 
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Булево.
//
Функция РазрешенаРаботаСНовостямиЧерезИнтернет() Экспорт

	Результат = ОбработкаНовостейВызовСервера.РазрешенаРаботаСНовостямиЧерезИнтернет();

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область РаботаСТекстомНовости

// Функция возвращает ХТМЛ или простой текст новости по ссылке на новость.
//
// Параметры:
//  лкНовости            - СправочникОбъект.Новость, Структура, Массив - данные новости или списка новостей;
//  ПараметрыОтображения - Структура или Неопределено, в которой передаются параметры для отображения новости. Список возможных параметров:
//    * ОтображатьЗаголовок - Булево.
//
// Возвращаемое значение
//  Строка.
//
Функция ПолучитьХТМЛТекстНовостей(лкНовости, ПараметрыОтображения = Неопределено) Экспорт

	Результат = ОбработкаНовостейВызовСервера.ПолучитьХТМЛТекстНовостей(лкНовости, ПараметрыОтображения);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПоискДанных

// Функция возвращает ссылку на ленту новостей по ее коду.
//
// Параметры:
//  ЛентаНовостейКод - Строка - код ленты новостей.
//
// Возвращаемое значение:
//   СправочникСсылка.ЛентыНовостей - ссылка на ленту новостей или пустая ссылка, если нет ленты новостей с таким кодом.
//
Функция ПолучитьЛентуНовостейПоКоду(ЛентаНовостейКод) Экспорт

	Результат = ОбработкаНовостейВызовСервера.ПолучитьЛентуНовостейПоКоду(ЛентаНовостейКод);

	Возврат Результат;

КонецФункции

#КонецОбласти