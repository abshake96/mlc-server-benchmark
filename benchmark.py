import argparse
from mlc_chat import ChatModule
from mlc_chat.callback import StreamToStdout

def main(model_name):
    # Create a ChatModule instance
    cm = ChatModule(model=model_name)
    
    output = cm.benchmark_generate(
       prompt="What is the meaning of life?",
       generate_length=1024,
    )
    print(output)

    # Print prefill and decode performance statistics
    print(f"Statistics: {cm.stats()}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Run mlc_chat with a given model name.')
    parser.add_argument('model_name', type=str, help='Model name to be used with ChatModule.')

    args = parser.parse_args()

    main(args.model_name)