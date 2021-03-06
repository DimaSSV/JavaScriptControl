

// При первом обращении помещает двоичные данные во временное хранилише и кеширует на сервере
//
// Возвращаемое значение:
//   Строка   - Адрес временного хранилища, где лежат двоичные данные подключаемого расширения скриптов
//
Функция АдресОсновногоРасширенияСкриптов() Экспорт 

	Скрипт = ПолучитьОбщийМакет("пс_ПодключаемыеСкрипты");
	Поток = Новый ПотокВПамяти;
	// отключаем проверку парава "Вывод"
	УстановитьПривилегированныйРежим(Истина);
	Скрипт.Записать(Поток);
	Возврат ПоместитьДанныеВоВременноеХранилище(Поток.ЗакрытьИПолучитьДвоичныеДанные());

КонецФункции // АдресОсновногоРасширенияСкриптов()


Функция АдресСкриптаРедактораКода() Экспорт
	
	app = Обработки.пс_РедакторКода.ПолучитьМакет("app");
	// отключаем проверку парава "Вывод"
	УстановитьПривилегированныйРежим(Истина);
	Чтение = Новый ЧтениеТекста(app.ОткрытьПотокДляЧтения(), КодировкаТекста.UTF8);	
	ТекстСкрипта = Чтение.Прочитать();
	Чтение.Закрыть();
	
	ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "[ts_worker]"
		, пс_СкриптыВызовСервера.НавигационнаяойСсылкаВременногоХранилища(АдресВоркераПоИмени("ts_worker")));
	ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "[editor_worker]"
		, пс_СкриптыВызовСервера.НавигационнаяойСсылкаВременногоХранилища(АдресВоркераПоИмени("editor_worker")));
	ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "[html_worker]"
		, пс_СкриптыВызовСервера.НавигационнаяойСсылкаВременногоХранилища(АдресВоркераПоИмени("html_worker")));
	ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "[json_worker]"
		, пс_СкриптыВызовСервера.НавигационнаяойСсылкаВременногоХранилища( АдресВоркераПоИмени("json_worker")));
	ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "[css_worker]"
		, пс_СкриптыВызовСервера.НавигационнаяойСсылкаВременногоХранилища(АдресВоркераПоИмени("css_worker")));
	
	Поток = Новый ПотокВПамяти;
	Запись = Новый ЗаписьТекста(Поток, КодировкаТекста.UTF8);
	Запись.Записать(ТекстСкрипта);
	Запись.Закрыть(); 
	Возврат ПоместитьДанныеВоВременноеХранилище(Поток.ЗакрытьИПолучитьДвоичныеДанные());
	
КонецФункции

Функция АдресРедактораКода() Экспорт
	
	АдресСкрипта = АдресСкриптаРедактораКода();
	Поток = Новый ПотокВПамяти;
	// отключаем проверку парава "Вывод"
	УстановитьПривилегированныйРежим(Истина);
	ХТМЛРедактора = Обработки.пс_РедакторКода.ПолучитьМакет("index");
	ХТМЛРедактора.УстановитьТекст(СтрЗаменить(ХТМЛРедактора.ПолучитьТекст()
		, "[АдресСкрипта]", пс_СкриптыВызовСервера.НавигационнаяойСсылкаВременногоХранилища(АдресСкрипта)));
	ХТМЛРедактора.Записать(Поток);	
	АдресРедактора = ПоместитьДанныеВоВременноеХранилище(Поток.ЗакрытьИПолучитьДвоичныеДанные());
	пс_СкриптыВызовСервера.ПоместитьВСерверныйКэш("АдресРедактораКода", АдресРедактора);
	Возврат АдресРедактора; 
	
КонецФункции

Функция ПоместитьДанныеВоВременноеХранилище(Данные)
	Возврат ПоместитьВоВременноеХранилище(Данные, Новый УникальныйИдентификатор);	
КонецФункции

Функция АдресВоркераПоИмени(Имя)
	
	Воркер = Обработки.пс_РедакторКода.ПолучитьМакет(Имя);
	Возврат ПоместитьДанныеВоВременноеХранилище(Воркер); 
	
КонецФункции
