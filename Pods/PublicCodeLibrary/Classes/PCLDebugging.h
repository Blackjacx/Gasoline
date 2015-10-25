/*!
 @file		PCLDebugging.h
 @brief		Macro Definitions to support debugging (compiled out in release builds)
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

typedef void(^PCLDebugBlock)(void);

#if defined( DEBUG ) && DEBUG == 1

#define PCLShowDebugAlert( message_fmt, ... ) { _PCLShowDebugAlert( [NSString stringWithFormat:message_fmt, ##__VA_ARGS__] ); }
#define PCLDebugExecuteBlock( block ) { _PCLDebugExecuteBlock( block ); }

#else

#define PCLShowDebugAlert( message_fmt, ... ) {}
#define PCLDebugExecBlock( block ) {}

#endif

inline void _PCLShowAlert( NSString * msg ) {

	[[[UIAlertView alloc] initWithTitle:@"Info <DEBUG>"
								message:msg
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

inline void _PCLDebugExecuteBlock( PCLDebugBlock block ) {

	block();
}